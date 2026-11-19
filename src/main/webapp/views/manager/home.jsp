<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="vi">
<head>
    <title>Trang chủ Manager</title>
</head>
<body>
<section class="app-section">
    <div class="container">
        <div class="app-card p-4">
            <span class="ah-eyebrow mb-2">Quản lý</span>
            <h1 class="h3 mb-2">Trang chủ Manager</h1>
            <p class="mb-1">Xin chào, <strong class="text-white"><c:out value="${sessionScope.account.fullName}"/></strong>.</p>
            <p class="text-secondary mb-4">Tài khoản: <c:out value="${sessionScope.account.userName}"/></p>
            <div class="d-flex flex-wrap gap-2">
                <a href="${pageContext.request.contextPath}/home" class="btn btn-ah">Trang chủ Video</a>
                <a href="${pageContext.request.contextPath}/video" class="btn btn-ghost">Video của tôi</a>
            </div>
        </div>
    </div>
</section>
</body>
</html>
