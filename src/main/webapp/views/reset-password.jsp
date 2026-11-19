<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="vi">
<head>
    <title>Đặt lại mật khẩu</title>
</head>
<body>
<section class="app-section">
    <div class="container">
        <div class="app-auth-wrap">
            <div class="app-card">
                <div class="app-card-header">
                    <span class="ah-eyebrow mb-2">Bảo mật</span>
                    <h1 class="h3 mb-1">Đặt lại mật khẩu</h1>
                    <p class="mb-0 text-secondary">
                        Email: <strong class="text-white"><c:out value="${sessionScope.resetEmail}"/></strong>
                    </p>
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

                    <c:choose>
                        <c:when test="${sessionScope.resetOtpVerified == true}">
                            <form action="${pageContext.request.contextPath}/reset-password" method="post" novalidate>
                                <input type="hidden" name="action" value="resetPassword">

                                <div class="mb-3">
                                    <label for="newPassword" class="form-label">Mật khẩu mới</label>
                                    <input type="password"
                                           id="newPassword"
                                           name="newPassword"
                                           placeholder="Tối thiểu 6 ký tự"
                                           class="form-control ${not empty errors.newPassword ? 'is-invalid' : ''}">
                                    <c:if test="${not empty errors.newPassword}">
                                        <div class="invalid-feedback"><c:out value="${errors.newPassword}"/></div>
                                    </c:if>
                                </div>

                                <div class="mb-4">
                                    <label for="confirmPassword" class="form-label">Xác nhận mật khẩu mới</label>
                                    <input type="password"
                                           id="confirmPassword"
                                           name="confirmPassword"
                                           placeholder="Nhập lại mật khẩu mới"
                                           class="form-control ${not empty errors.confirmPassword ? 'is-invalid' : ''}">
                                    <c:if test="${not empty errors.confirmPassword}">
                                        <div class="invalid-feedback"><c:out value="${errors.confirmPassword}"/></div>
                                    </c:if>
                                </div>

                                <button type="submit" class="btn btn-ah w-100">Đổi mật khẩu</button>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <form action="${pageContext.request.contextPath}/reset-password" method="post" novalidate>
                                <div class="mb-4">
                                    <label for="otp" class="form-label">Mã OTP xác nhận (6 chữ số)</label>
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
                                    <button type="submit" name="action" value="verifyOtp" class="btn btn-ah flex-fill">Xác nhận OTP</button>
                                    <button type="submit" name="action" value="resend" class="btn btn-ghost" formnovalidate>Gửi lại OTP</button>
                                </div>
                            </form>
                        </c:otherwise>
                    </c:choose>

                    <hr class="ah-divider my-4">
                    <p class="text-center mb-0">
                        <a href="${pageContext.request.contextPath}/forgot-password">Dùng email khác</a>
                        <span class="mx-2 text-secondary">|</span>
                        <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
                    </p>
                </div>
            </div>
        </div>
    </div>
</section>
</body>
</html>
