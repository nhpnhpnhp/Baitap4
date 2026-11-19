package vn.iotstar.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.iotstar.service.UserService;
import vn.iotstar.service.impl.UserServiceImpl;
import vn.iotstar.util.Constant;

@SuppressWarnings("serial")
@WebServlet(urlPatterns = "/register")
public class RegisterController extends HttpServlet {
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    private static final Pattern USERNAME_PATTERN = Pattern.compile("^[a-zA-Z0-9._-]{3,100}$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^\\+?[0-9]{9,15}$");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("account") != null) {
            resp.sendRedirect(req.getContextPath() + "/waiting");
            return;
        }
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("username")) {
                    resp.sendRedirect(req.getContextPath() + "/login");
                    return;
                }
            }
        }
        req.getRequestDispatcher(Constant.Path.REGISTER).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setCharacterEncoding("UTF-8");
        req.setCharacterEncoding("UTF-8");

        String username = trim(req.getParameter("username"));
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String email = trim(req.getParameter("email"));
        String fullname = trim(req.getParameter("fullname"));
        String phone = trim(req.getParameter("phone"));

        password = password == null ? "" : password;
        confirmPassword = confirmPassword == null ? "" : confirmPassword;

        req.setAttribute("username", username);
        req.setAttribute("email", email);
        req.setAttribute("fullname", fullname);
        req.setAttribute("phone", phone);

        Map<String, String> errors = new HashMap<>();
        UserService service = new UserServiceImpl();

        if (username.isEmpty()) {
            errors.put("username", "Tên đăng nhập không được để trống.");
        } else if (!USERNAME_PATTERN.matcher(username).matches()) {
            errors.put("username", "Tên đăng nhập dài 3-100 ký tự, chỉ gồm chữ, số và ký tự . _ -");
        } else if (service.checkExistUsername(username)) {
            errors.put("username", "Tên đăng nhập đã tồn tại.");
        }

        if (email.isEmpty()) {
            errors.put("email", "Email không được để trống.");
        } else if (email.length() > 255 || !EMAIL_PATTERN.matcher(email).matches()) {
            errors.put("email", "Email không đúng định dạng.");
        } else if (service.checkExistEmail(email)) {
            errors.put("email", "Email đã được sử dụng.");
        }

        if (password.isEmpty()) {
            errors.put("password", "Mật khẩu không được để trống.");
        } else if (password.length() < 6 || password.length() > 100) {
            errors.put("password", "Mật khẩu phải từ 6 đến 100 ký tự.");
        }

        if (confirmPassword.isEmpty()) {
            errors.put("confirmPassword", "Vui lòng xác nhận mật khẩu.");
        } else if (!confirmPassword.equals(password)) {
            errors.put("confirmPassword", "Mật khẩu xác nhận không khớp.");
        }

        if (fullname.isEmpty()) {
            errors.put("fullname", "Họ tên không được để trống.");
        } else if (fullname.length() < 2 || fullname.length() > 255) {
            errors.put("fullname", "Họ tên phải từ 2 đến 255 ký tự.");
        }

        if (phone.isEmpty()) {
            errors.put("phone", "Số điện thoại không được để trống.");
        } else if (!PHONE_PATTERN.matcher(phone).matches()) {
            errors.put("phone", "Số điện thoại không hợp lệ (9-15 chữ số).");
        }

        if (!errors.isEmpty()) {
            req.setAttribute("errors", errors);
            req.getRequestDispatcher(Constant.Path.REGISTER).forward(req, resp);
            return;
        }

        boolean isSuccess = service.register(username, password, email, fullname, phone);
        if (isSuccess) {
            boolean mailSent = service.sendRegisterOtp(email);
            HttpSession session = req.getSession(true);
            session.setAttribute("verifyEmail", email);
            if (!mailSent) {
                session.setAttribute("otpWarning",
                        "Tài khoản đã được tạo nhưng chưa gửi được email OTP. Vui lòng kiểm tra cấu hình SMTP và bấm Gửi lại OTP.");
            } else {
                session.setAttribute("otpMessage", "Mã OTP kích hoạt (hiệu lực 5 phút) đã được gửi đến email của bạn.");
            }
            resp.sendRedirect(req.getContextPath() + "/verify-otp");
        } else {
            req.setAttribute("alert", "Không thể tạo tài khoản. Vui lòng thử lại.");
            req.getRequestDispatcher(Constant.Path.REGISTER).forward(req, resp);
        }
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
