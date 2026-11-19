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
@WebServlet(urlPatterns = "/forgot-password")
public class ForgotPasswordController extends HttpServlet {
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    private final UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.removeAttribute("resetOtpVerified");
        }
        req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String email = req.getParameter("email");
        email = email == null ? "" : email.trim();
        req.setAttribute("email", email);

        Map<String, String> errors = new HashMap<>();
        if (email.isEmpty()) {
            errors.put("email", "Vui lòng nhập email đã đăng ký.");
        } else if (email.length() > 255 || !EMAIL_PATTERN.matcher(email).matches()) {
            errors.put("email", "Email không đúng định dạng.");
        }

        if (!errors.isEmpty()) {
            req.setAttribute("errors", errors);
            req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
            return;
        }

        String result = userService.sendForgotPasswordOtp(email);
        if ("SENT".equals(result)) {
            HttpSession session = req.getSession(true);
            session.setAttribute("resetEmail", email);
            session.removeAttribute("resetOtpVerified");
            session.setAttribute("resetMessage", "Mã OTP đặt lại mật khẩu (hiệu lực 5 phút) đã được gửi đến email của bạn.");
            resp.sendRedirect(req.getContextPath() + "/reset-password");
        } else if ("NOT_FOUND".equals(result)) {
            errors.put("email", "Email không tồn tại trong hệ thống.");
            req.setAttribute("errors", errors);
            req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
        } else if ("NOT_ACTIVE".equals(result)) {
            req.setAttribute("alert", "Tài khoản chưa được kích hoạt. Vui lòng kích hoạt tài khoản trước.");
            req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
        } else {
            req.setAttribute("alert", "Không thể gửi email OTP. Vui lòng thử lại sau.");
            req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
        }
    }
}
