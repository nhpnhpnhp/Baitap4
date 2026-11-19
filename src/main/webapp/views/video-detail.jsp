<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="vi">
<head>
    <title>Chi tiết Video</title>
</head>
<body>
<section class="app-section">
    <div class="container">
        <div class="mb-4 d-flex flex-wrap gap-2">
            <a href="${pageContext.request.contextPath}/home" class="btn btn-sm btn-ghost">&larr; Về trang chủ</a>
            <a href="${pageContext.request.contextPath}/video" class="btn btn-sm btn-ghost">Video của tôi</a>
        </div>

        <c:choose>
            <c:when test="${error != null}">
                <div class="alert app-alert-danger p-4" role="alert">
                    <h1 class="h5 mb-1">Không tìm thấy video</h1>
                    <p class="mb-0"><c:out value="${error}"/></p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="app-card">
                    <div class="app-card-body">
                        <div class="mb-4">
                            <c:choose>
                                <c:when test="${not empty video.videoPath}">
                                    <video class="app-video-player" controls>
                                        <source src="${pageContext.request.contextPath}/video-file?fname=${video.videoPath}">
                                        Trình duyệt của bạn không hỗ trợ phát video.
                                    </video>
                                </c:when>
                                <c:otherwise>
                                    <div class="p-5 text-center border border-secondary border-opacity-25 rounded">
                                        <p class="mb-0 text-secondary">Video này chưa có file phát.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="d-flex flex-wrap justify-content-between align-items-start gap-3 mb-3">
                            <div>
                                <h1 class="h3 mb-2"><c:out value="${video.title}"/></h1>
                                <div class="d-flex flex-wrap gap-2">
                                    <span class="app-meta-pill">Người đăng: <strong class="text-white"><c:out value="${video.user != null ? video.user.fullName : 'Hệ thống'}"/></strong></span>
                                    <span class="app-meta-pill">Danh mục: <strong class="text-white"><c:out value="${video.category != null ? video.category.categoryname : 'Không có'}"/></strong></span>
                                    <span class="app-meta-pill">Lượt xem: <strong class="text-white">${video.views}</strong></span>
                                    <span class="app-meta-pill">Ngày tạo: <c:out value="${video.createdDate}"/></span>
                                </div>
                            </div>

                            <c:if test="${video.user != null && video.user.id == sessionScope.account.id}">
                                <div class="d-flex gap-2">
                                    <a href="${pageContext.request.contextPath}/video/edit?id=${video.videoId}" class="btn btn-sm btn-ah">Sửa video</a>
                                    <a href="${pageContext.request.contextPath}/video/delete?id=${video.videoId}"
                                       class="btn btn-sm btn-outline-danger"
                                       onclick="return confirm('Bạn có chắc muốn xóa video này?');">Xóa video</a>
                                </div>
                            </c:if>
                        </div>

                        <c:if test="${not empty video.description}">
                            <hr class="ah-divider my-3">
                            <h2 class="h6 text-uppercase text-secondary mb-2">Mô tả</h2>
                            <p class="mb-0"><c:out value="${video.description}"/></p>
                        </c:if>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</section>
</body>
</html>
