package vn.iotstar.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.iotstar.model.User;
import vn.iotstar.service.UserService;
import vn.iotstar.service.impl.UserServiceImpl;
import vn.iotstar.util.Constant;

@SuppressWarnings("serial")
@WebServlet(urlPatterns = "/login")
public class LoginController extends HttpServlet {
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("account") != null) {
            resp.sendRedirect(req.getContextPath() + "/waiting");
            return;
        }
        if (session != null && session.getAttribute("flashMessage") != null) {
            req.setAttribute("message", session.getAttribute("flashMessage"));
            session.removeAttribute("flashMessage");
        }
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("username")) {
                    UserService service = new UserServiceImpl();
                    User user = service.get(cookie.getValue());
                    if (user != null && user.isActive()) {
                        session = req.getSession(true);
                        session.setAttribute("username", cookie.getValue());
                        session.setAttribute("account", user);
                        resp.sendRedirect(req.getContextPath() + "/waiting");
                        return;
                    }
                }
            }
        }
        req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html");
        resp.setCharacterEncoding("UTF-8");
        req.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        username = username == null ? "" : username.trim();
        password = password == null ? "" : password;
        boolean isRememberMe = "on".equals(req.getParameter("remember"));

        req.setAttribute("username", username);
        req.setAttribute("remember", isRememberMe);

        Map<String, String> errors = new HashMap<>();
        if (username.isEmpty()) {
            errors.put("username", "Vui lòng nhập tên đăng nhập hoặc email.");
        } else if (username.contains("@") && !EMAIL_PATTERN.matcher(username).matches()) {
            errors.put("username", "Email không đúng định dạng.");
        }

        if (password.isEmpty()) {
            errors.put("password", "Vui lòng nhập mật khẩu.");
        }

        if (!errors.isEmpty()) {
            req.setAttribute("errors", errors);
            req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
            return;
        }

        UserService service = new UserServiceImpl();
        User user = service.login(username, password);
        if (user == null && username.contains("@")) {
            User byEmail = service.findByEmail(username);
            if (byEmail != null) {
                user = service.login(byEmail.getUserName(), password);
            }
        }

        if (user == null) {
            req.setAttribute("alert", "Tài khoản hoặc mật khẩu không đúng.");
            req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
            return;
        }

        if (!user.isActive()) {
            HttpSession session = req.getSession(true);
            session.setAttribute("verifyEmail", user.getEmail());
            req.setAttribute("alert", "Tài khoản chưa được kích hoạt. Vui lòng nhập mã OTP đã gửi qua email.");
            req.setAttribute("needVerify", true);
            req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
            return;
        }

        HttpSession session = req.getSession(true);
        session.setAttribute("account", user);
        if (isRememberMe) {
            saveRemeberMe(resp, user.getUserName());
        }
        resp.sendRedirect(req.getContextPath() + "/waiting");
    }

    private void saveRemeberMe(HttpServletResponse response, String username) {
        Cookie cookie = new Cookie(Constant.COOKIE_REMEMBER, username);
        cookie.setMaxAge(30 * 60);
        response.addCookie(cookie);
    }
}
