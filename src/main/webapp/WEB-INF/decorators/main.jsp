<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="vi">
<head>
    <script>document.documentElement.classList.add('js')</script>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><sitemesh:write property="title"/> | VideoHub</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/autohaus/css/vendor/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/autohaus/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/style.css">
    <sitemesh:write property="head"/>
</head>
<body class="app-body">
    <a class="ah-skip" href="#main">Chuyển đến nội dung</a>

    <header>
        <nav class="ah-nav scrolled" aria-label="Điều hướng chính">
            <div class="container">
                <a class="ah-brand" href="${pageContext.request.contextPath}${sessionScope.account != null ? '/home' : '/login'}">
                    <span class="ah-brand-mark" aria-hidden="true">
                        <svg viewBox="0 0 24 24" fill="none">
                            <path d="M8 5.5v13l11-6.5-11-6.5z" fill="#fff"/>
                        </svg>
                    </span>
                    Video<b>Hub</b>
                </a>

                <ul class="ah-nav-links ah-nav-desktop" role="list">
                    <c:choose>
                        <c:when test="${sessionScope.account != null}">
                            <li><a href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
                            <li><a href="${pageContext.request.contextPath}/video">Video của tôi</a></li>
                            <li><a href="${pageContext.request.contextPath}/video/add">Đăng video</a></li>
                            <c:if test="${sessionScope.account.roleid == 1}">
                                <li><a href="${pageContext.request.contextPath}/admin/categories">Danh mục</a></li>
                            </c:if>
                        </c:when>
                        <c:otherwise>
                            <li><a href="${pageContext.request.contextPath}/login">Đăng nhập</a></li>
                            <li><a href="${pageContext.request.contextPath}/register">Đăng ký</a></li>
                            <li><a href="${pageContext.request.contextPath}/forgot-password">Quên mật khẩu</a></li>
                        </c:otherwise>
                    </c:choose>
                </ul>

                <div class="ah-nav-cta ah-nav-desktop">
                    <c:choose>
                        <c:when test="${sessionScope.account != null}">
                            <a href="${pageContext.request.contextPath}/member/myaccount" class="btn btn-ghost btn-sm">
                                <c:out value="${sessionScope.account.fullName}"/>
                            </a>
                            <a href="${pageContext.request.contextPath}/logout" class="btn btn-ah btn-sm">Đăng xuất</a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-ghost btn-sm">Đăng nhập</a>
                            <a href="${pageContext.request.contextPath}/register" class="btn btn-ah btn-sm">Đăng ký</a>
                        </c:otherwise>
                    </c:choose>
                </div>

                <button class="ah-burger" type="button" aria-label="Mở menu" aria-expanded="false" aria-controls="mobileMenu">
                    <span></span><span></span><span></span>
                </button>
            </div>
        </nav>

        <div class="ah-overlay" aria-hidden="true"></div>
        <div class="ah-mobile-menu" id="mobileMenu" aria-label="Menu di động">
            <c:choose>
                <c:when test="${sessionScope.account != null}">
                    <a href="${pageContext.request.contextPath}/home">Trang chủ</a>
                    <a href="${pageContext.request.contextPath}/video">Video của tôi</a>
                    <a href="${pageContext.request.contextPath}/video/add">Đăng video mới</a>
                    <c:if test="${sessionScope.account.roleid == 1}">
                        <a href="${pageContext.request.contextPath}/admin/categories">Quản lý danh mục</a>
                    </c:if>
                    <hr>
                    <a href="${pageContext.request.contextPath}/member/myaccount" class="btn btn-ghost">
                        <c:out value="${sessionScope.account.fullName}"/>
                    </a>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-ah">Đăng xuất</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
                    <a href="${pageContext.request.contextPath}/register">Đăng ký</a>
                    <a href="${pageContext.request.contextPath}/forgot-password">Quên mật khẩu</a>
                    <hr>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-ghost">Đăng nhập</a>
                    <a href="${pageContext.request.contextPath}/register" class="btn btn-ah">Tạo tài khoản</a>
                </c:otherwise>
            </c:choose>
        </div>
    </header>

    <main id="main" class="app-main">
        <sitemesh:write property="body"/>
    </main>

    <footer class="ah-footer">
        <div class="container">
            <div class="row g-4">
                <div class="col-lg-5">
                    <a class="ah-brand mb-3" href="${pageContext.request.contextPath}${sessionScope.account != null ? '/home' : '/login'}">
                        <span class="ah-brand-mark" aria-hidden="true">
                            <svg viewBox="0 0 24 24" fill="none">
                                <path d="M8 5.5v13l11-6.5-11-6.5z" fill="#fff"/>
                            </svg>
                        </span>
                        Video<b>Hub</b>
                    </a>
                    <p>Hệ thống quản lý và chia sẻ video xây dựng trên Java Servlet, JSP, JPA, SiteMesh 3 và Bootstrap 5 (Autohaus theme).</p>
                </div>
                <div class="col-6 col-lg-3">
                    <h5>Điều hướng</h5>
                    <c:choose>
                        <c:when test="${sessionScope.account != null}">
                            <a href="${pageContext.request.contextPath}/home">Trang chủ</a><br>
                            <a href="${pageContext.request.contextPath}/video">Video của tôi</a><br>
                            <a href="${pageContext.request.contextPath}/video/add">Đăng video mới</a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login">Đăng nhập</a><br>
                            <a href="${pageContext.request.contextPath}/register">Đăng ký tài khoản</a><br>
                            <a href="${pageContext.request.contextPath}/forgot-password">Quên mật khẩu</a>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="col-6 col-lg-4">
                    <h5>Thông tin bài tập</h5>
                    <p class="mb-1">Lập trình Web Java — Bài tập 02</p>
                    <p class="mb-0">SiteMesh Decorator 3 &amp; Form Validation</p>
                </div>
            </div>
            <div class="ah-footer-bottom">
                <p class="m-0">&copy; 2026 VideoHub. Thiết kế dựa trên Autohaus Bootstrap 5.</p>
                <p class="m-0">Jakarta Servlet 6 &middot; SiteMesh 3 &middot; JPA</p>
            </div>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/assets/autohaus/js/vendor/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/autohaus/js/main.js"></script>
</body>
</html>
