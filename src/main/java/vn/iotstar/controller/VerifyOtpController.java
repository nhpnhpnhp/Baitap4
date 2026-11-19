package vn.iotstar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.iotstar.service.UserService;
import vn.iotstar.service.impl.UserServiceImpl;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;

@SuppressWarnings("serial")
@WebServlet(urlPatterns = "/verify-otp")
public class VerifyOtpController extends HttpServlet {
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    private static final Pattern OTP_PATTERN = Pattern.compile("^[0-9]{6}$");
    private final UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            if (session.getAttribute("otpWarning") != null) {
                req.setAttribute("alert", session.getAttribute("otpWarning"));
                session.removeAttribute("otpWarning");
            }
            if (session.getAttribute("otpMessage") != null) {
                req.setAttribute("message", session.getAttribute("otpMessage"));
                session.removeAttribute("otpMessage");
            }
            if (req.getAttribute("email") == null && session.getAttribute("verifyEmail") != null) {
                req.setAttribute("email", session.getAttribute("verifyEmail"));
            }
        }
        req.getRequestDispatcher("/views/verify-otp.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String email = req.getParameter("email");
        email = email == null ? "" : email.trim();
        String action = req.getParameter("action");

        req.setAttribute("email", email);

        Map<String, String> errors = new HashMap<>();
        if (email.isEmpty()) {
            errors.put("email", "Vui lòng nhập email đã đăng ký.");
        } else if (!EMAIL_PATTERN.matcher(email).matches()) {
            errors.put("email", "Email không đúng định dạng.");
        }

        if ("resend".equals(action)) {
            if (!errors.isEmpty()) {
                req.setAttribute("errors", errors);
                req.getRequestDispatcher("/views/verify-otp.jsp").forward(req, resp);
                return;
            }
            HttpSession session = req.getSession(true);
            session.setAttribute("verifyEmail", email);
            boolean sent = userService.sendRegisterOtp(email);
            if (sent) {
                req.setAttribute("message", "Đã gửi lại mã OTP mới (hiệu lực 5 phút) tới email của bạn.");
            } else {
                req.setAttribute("alert", "Không thể gửi lại OTP. Kiểm tra lại email hoặc trạng thái tài khoản.");
            }
            req.getRequestDispatcher("/views/verify-otp.jsp").forward(req, resp);
            return;
        }

        String otp = req.getParameter("otp");
        otp = otp == null ? "" : otp.trim();
        if (otp.isEmpty()) {
            errors.put("otp", "Vui lòng nhập mã OTP.");
        } else if (!OTP_PATTERN.matcher(otp).matches()) {
            errors.put("otp", "Mã OTP phải gồm đúng 6 chữ số.");
        }

        if (!errors.isEmpty()) {
            req.setAttribute("errors", errors);
            req.getRequestDispatcher("/views/verify-otp.jsp").forward(req, resp);
            return;
        }

        HttpSession session = req.getSession(true);
        session.setAttribute("verifyEmail", email);

        String result = userService.verifyRegisterOtp(email, otp);
        if ("OK".equals(result)) {
            session.removeAttribute("verifyEmail");
            session.setAttribute("flashMessage", "Kích hoạt tài khoản thành công! Vui lòng đăng nhập.");
            resp.sendRedirect(req.getContextPath() + "/login");
        } else if ("ALREADY_ACTIVE".equals(result)) {
            session.removeAttribute("verifyEmail");
            session.setAttribute("flashMessage", "Tài khoản đã được kích hoạt trước đó. Vui lòng đăng nhập.");
            resp.sendRedirect(req.getContextPath() + "/login");
        } else if ("EXPIRED".equals(result)) {
            errors.put("otp", "Mã OTP đã hết hạn. Vui lòng bấm Gửi lại OTP.");
            req.setAttribute("errors", errors);
            req.getRequestDispatcher("/views/verify-otp.jsp").forward(req, resp);
        } else {
            errors.put("otp", "Mã OTP hoặc email không đúng.");
            req.setAttribute("errors", errors);
            req.getRequestDispatcher("/views/verify-otp.jsp").forward(req, resp);
        }
    }
}
