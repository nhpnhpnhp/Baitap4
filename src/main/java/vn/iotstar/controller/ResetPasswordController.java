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
@WebServlet(urlPatterns = "/reset-password")
public class ResetPasswordController extends HttpServlet {
    private static final Pattern OTP_PATTERN = Pattern.compile("^[0-9]{6}$");
    private final UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("resetEmail") == null) {
            resp.sendRedirect(req.getContextPath() + "/forgot-password");
            return;
        }
        if (session.getAttribute("resetMessage") != null) {
            req.setAttribute("message", session.getAttribute("resetMessage"));
            session.removeAttribute("resetMessage");
        }
        req.getRequestDispatcher("/views/reset-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("resetEmail") == null) {
            resp.sendRedirect(req.getContextPath() + "/forgot-password");
            return;
        }

        String email = (String) session.getAttribute("resetEmail");
        String action = req.getParameter("action");

        if ("resend".equals(action)) {
            session.removeAttribute("resetOtpVerified");
            String result = userService.sendForgotPasswordOtp(email);
            if ("SENT".equals(result)) {
                req.setAttribute("message", "Đã gửi lại mã OTP mới (hiệu lực 5 phút) tới email của bạn.");
            } else {
                req.setAttribute("alert", "Không thể gửi lại OTP. Vui lòng thử lại sau.");
            }
            req.getRequestDispatcher("/views/reset-password.jsp").forward(req, resp);
            return;
        }

        if ("verifyOtp".equals(action)) {
            String otp = req.getParameter("otp");
            otp = otp == null ? "" : otp.trim();
            Map<String, String> errors = new HashMap<>();

            if (otp.isEmpty()) {
                errors.put("otp", "Vui lòng nhập mã OTP.");
            } else if (!OTP_PATTERN.matcher(otp).matches()) {
                errors.put("otp", "Mã OTP phải gồm đúng 6 chữ số.");
            }

            if (!errors.isEmpty()) {
                req.setAttribute("errors", errors);
                req.getRequestDispatcher("/views/reset-password.jsp").forward(req, resp);
                return;
            }

            String result = userService.verifyForgotPasswordOtp(email, otp);
            if ("OK".equals(result)) {
                session.setAttribute("resetOtpVerified", Boolean.TRUE);
                req.setAttribute("message", "Xác thực OTP thành công. Vui lòng nhập mật khẩu mới.");
            } else if ("EXPIRED".equals(result)) {
                errors.put("otp", "Mã OTP đã hết hạn. Vui lòng bấm Gửi lại OTP.");
                req.setAttribute("errors", errors);
            } else {
                errors.put("otp", "Mã OTP không đúng.");
                req.setAttribute("errors", errors);
            }
            req.getRequestDispatcher("/views/reset-password.jsp").forward(req, resp);
            return;
        }

        if ("resetPassword".equals(action)) {
            if (!Boolean.TRUE.equals(session.getAttribute("resetOtpVerified"))) {
                req.setAttribute("alert", "Vui lòng xác thực OTP hợp lệ trước khi đổi mật khẩu.");
                req.getRequestDispatcher("/views/reset-password.jsp").forward(req, resp);
                return;
            }
            String newPassword = req.getParameter("newPassword");
            String confirmPassword = req.getParameter("confirmPassword");
            newPassword = newPassword == null ? "" : newPassword;
            confirmPassword = confirmPassword == null ? "" : confirmPassword;

            Map<String, String> errors = new HashMap<>();
            if (newPassword.isEmpty()) {
                errors.put("newPassword", "Vui lòng nhập mật khẩu mới.");
            } else if (newPassword.length() < 6 || newPassword.length() > 100) {
                errors.put("newPassword", "Mật khẩu mới phải từ 6 đến 100 ký tự.");
            }

            if (confirmPassword.isEmpty()) {
                errors.put("confirmPassword", "Vui lòng xác nhận mật khẩu mới.");
            } else if (!confirmPassword.equals(newPassword)) {
                errors.put("confirmPassword", "Mật khẩu xác nhận không khớp.");
            }

            if (!errors.isEmpty()) {
                req.setAttribute("errors", errors);
                req.getRequestDispatcher("/views/reset-password.jsp").forward(req, resp);
                return;
            }

            boolean updated = userService.resetPassword(email, newPassword);
            if (updated) {
                session.removeAttribute("resetEmail");
                session.removeAttribute("resetOtpVerified");
                session.setAttribute("flashMessage", "Đổi mật khẩu thành công! Vui lòng đăng nhập.");
                resp.sendRedirect(req.getContextPath() + "/login");
            } else {
                req.setAttribute("alert", "Không thể đổi mật khẩu. Vui lòng thử lại.");
                req.getRequestDispatcher("/views/reset-password.jsp").forward(req, resp);
            }
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/reset-password");
    }
}
