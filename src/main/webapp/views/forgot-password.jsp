<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="vi">
<head>
    <title>Quên mật khẩu</title>
</head>
<body>
<section class="app-section">
    <div class="container">
        <div class="app-auth-wrap">
            <div class="app-card">
                <div class="app-card-header">
                    <span class="ah-eyebrow mb-2">Khôi phục tài khoản</span>
                    <h1 class="h3 mb-1">Quên mật khẩu</h1>
                    <p class="mb-0 text-secondary">Nhập email đã đăng ký để nhận mã OTP đặt lại mật khẩu.</p>
                </div>
                <div class="app-card-body">
                    <c:if test="${alert != null}">
                        <div class="alert app-alert-danger mb-3" role="alert">
                            <c:out value="${alert}"/>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/forgot-password" method="post" novalidate>
                        <div class="mb-4">
                            <label for="email" class="form-label">Email đã đăng ký</label>
                            <input type="email"
                                   id="email"
                                   name="email"
                                   value="<c:out value='${email}'/>"
                                   placeholder="you@example.com"
                                   class="form-control ${not empty errors.email ? 'is-invalid' : ''}">
                            <c:if test="${not empty errors.email}">
                                <div class="invalid-feedback"><c:out value="${errors.email}"/></div>
                            </c:if>
                        </div>

                        <button type="submit" class="btn btn-ah w-100">Gửi mã OTP</button>
                    </form>

                    <hr class="ah-divider my-4">
                    <p class="text-center mb-0">
                        <a href="${pageContext.request.contextPath}/login">Quay lại đăng nhập</a>
                    </p>
                </div>
            </div>
        </div>
    </div>
</section>
</body>
</html>
