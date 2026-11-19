<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="vi">
<head>
    <title>Trang chủ</title>
</head>
<body>
<section class="app-page-header">
    <div class="container">
        <div class="d-flex flex-wrap justify-content-between align-items-end gap-3">
            <div>
                <span class="ah-eyebrow mb-2">Không gian video</span>
                <h1 class="h2 mb-2">Xin chào, <span class="text-blue"><c:out value="${sessionScope.account.fullName}"/></span></h1>
                <p class="mb-0 text-secondary">
                    Tài khoản: <strong class="text-white"><c:out value="${sessionScope.account.userName}"/></strong>
                    &middot; Khám phá 10 video mới nhất trong hệ thống.
                </p>
            </div>
            <div class="d-flex flex-wrap gap-2">
                <a href="${pageContext.request.contextPath}/video" class="btn btn-ghost">Video của tôi</a>
                <a href="${pageContext.request.contextPath}/video/add" class="btn btn-ah">+ Đăng video mới</a>
            </div>
        </div>
    </div>
</section>

<section class="app-section">
    <div class="container">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="h4 mb-0">10 Video mới nhất</h2>
            <span class="text-secondary small">Hiển thị ${empty videos ? 0 : videos.size()} video</span>
        </div>

        <c:choose>
            <c:when test="${empty videos}">
                <div class="app-card p-5 text-center">
                    <h3 class="h5 mb-2">Chưa có video nào</h3>
                    <p class="text-secondary mb-4">Hãy là người đầu tiên đăng tải video lên hệ thống.</p>
                    <a href="${pageContext.request.contextPath}/video/add" class="btn btn-ah">Đăng video đầu tiên</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row g-4">
                    <c:forEach items="${videos}" var="v" varStatus="st">
                        <div class="col-md-6 col-lg-4">
                            <article class="app-video-card">
                                <a href="${pageContext.request.contextPath}/video/detail?id=${v.videoId}" class="app-video-thumb text-decoration-none">
                                    <span class="app-video-badge">
                                        #<c:out value="${st.index + 1}"/>
                                        <c:if test="${v.category != null}">
                                            &middot; <c:out value="${v.category.categoryname}"/>
                                        </c:if>
                                    </span>
                                    <span class="app-play-icon" aria-hidden="true">
                                        <svg width="22" height="22" viewBox="0 0 24 24" fill="currentColor">
                                            <path d="M8 5.5v13l11-6.5-11-6.5z"/>
                                        </svg>
                                    </span>
                                </a>
                                <div class="p-3 d-flex flex-column flex-grow-1">
                                    <h3 class="h5 mb-2">
                                        <a href="${pageContext.request.contextPath}/video/detail?id=${v.videoId}" class="text-white text-decoration-none">
                                            <c:out value="${v.title}"/>
                                        </a>
                                    </h3>
                                    <p class="small text-secondary mb-3 flex-grow-1">
                                        <c:choose>
                                            <c:when test="${not empty v.description}">
                                                <c:out value="${v.description}"/>
                                            </c:when>
                                            <c:otherwise>Không có mô tả.</c:otherwise>
                                        </c:choose>
                                    </p>
                                    <div class="d-flex justify-content-between align-items-center small text-secondary border-top border-secondary border-opacity-25 pt-2 mb-3">
                                        <span><c:out value="${v.user != null ? v.user.fullName : 'Hệ thống'}"/></span>
                                        <span>${v.views} lượt xem</span>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <span class="small text-secondary"><c:out value="${v.createdDate}"/></span>
                                        <a href="${pageContext.request.contextPath}/video/detail?id=${v.videoId}" class="btn btn-sm btn-ghost">Xem video</a>
                                    </div>
                                </div>
                            </article>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</section>
</body>
</html>
