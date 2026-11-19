<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="vi">
<head>
    <title>Xác nhận OTP</title>
</head>
<body>
<section class="app-section">
    <div class="container">
        <div class="app-auth-wrap">
            <div class="app-card">
                <div class="app-card-header">
                    <span class="ah-eyebrow mb-2">Kích hoạt tài khoản</span>
                    <h1 class="h3 mb-1">Xác thực mã OTP</h1>
                    <p class="mb-0 text-secondary">Nhập email đăng ký và mã OTP 6 chữ số đã gửi về hộp thư của bạn.</p>
                </div>
                <div class="app-card-body">
                    <c:if test="${message != null}">
                        <div class="alert app-alert-success mb-3" role="alert">
                            <c:out value="${message}"/>
                        </div>
                    </c:if>
                    <c:if test="${alert != null}">
                        <div class="alert app-alert-danger mb-3" role="alert">
                            <c:out value="${alert}"/>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/verify-otp" method="post" novalidate>
                        <div class="mb-3">
                            <label for="email" class="form-label">Email đăng ký</label>
                            <input type="email"
                                   id="email"
                                   name="email"
                                   value="<c:out value='${email != null ? email : param.email}'/>"
                                   placeholder="you@example.com"
                                   class="form-control ${not empty errors.email ? 'is-invalid' : ''}">
                            <c:if test="${not empty errors.email}">
                                <div class="invalid-feedback"><c:out value="${errors.email}"/></div>
                            </c:if>
                        </div>

                        <div class="mb-4">
                            <label for="otp" class="form-label">Mã OTP (6 chữ số)</label>
                            <input type="text"
                                   id="otp"
                                   name="otp"
                                   maxlength="6"
                                   placeholder="Nhập 6 chữ số OTP"
                                   class="form-control ${not empty errors.otp ? 'is-invalid' : ''}">
                            <c:if test="${not empty errors.otp}">
                                <div class="invalid-feedback"><c:out value="${errors.otp}"/></div>
                            </c:if>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" name="action" value="verify" class="btn btn-ah flex-fill">Xác nhận kích hoạt</button>
                            <button type="submit" name="action" value="resend" class="btn btn-ghost" formnovalidate>Gửi lại OTP</button>
                        </div>
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
