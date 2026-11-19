<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="vi">
<head>
    <title>Video của tôi</title>
</head>
<body>
<section class="app-page-header">
    <div class="container">
        <div class="d-flex flex-wrap justify-content-between align-items-end gap-3">
            <div>
                <span class="ah-eyebrow mb-2">Quản lý nội dung</span>
                <h1 class="h2 mb-2">Danh sách Video của tôi</h1>
                <p class="mb-0 text-secondary">Tổng số: <strong class="text-white">${totalVideos}</strong> video đã tải lên.</p>
            </div>
            <a href="${pageContext.request.contextPath}/video/add" class="btn btn-ah">+ Thêm video mới</a>
        </div>
    </div>
</section>

<section class="app-section">
    <div class="container">
        <c:choose>
            <c:when test="${empty videos}">
                <div class="app-card p-5 text-center">
                    <h2 class="h5 mb-2">Bạn chưa có video nào</h2>
                    <p class="text-secondary mb-4">Tải lên video đầu tiên của bạn để bắt đầu quản lý.</p>
                    <a href="${pageContext.request.contextPath}/video/add" class="btn btn-ah">+ Thêm video mới</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="app-card overflow-hidden">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle app-table">
                            <thead>
                                <tr>
                                    <th>STT</th>
                                    <th>Tiêu đề</th>
                                    <th>Mô tả</th>
                                    <th>Danh mục</th>
                                    <th>Lượt xem</th>
                                    <th>Ngày tạo</th>
                                    <th class="text-end">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${videos}" var="v" varStatus="st">
                                    <tr>
                                        <td>${(currentPage - 1) * 6 + st.index + 1}</td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/video/detail?id=${v.videoId}" class="fw-semibold text-white">
                                                <c:out value="${v.title}"/>
                                            </a>
                                        </td>
                                        <td class="text-secondary"><c:out value="${v.description}"/></td>
                                        <td>
                                            <c:if test="${v.category != null}">
                                                <span class="badge bg-primary bg-opacity-25 text-info border border-primary border-opacity-25">
                                                    <c:out value="${v.category.categoryname}"/>
                                                </span>
                                            </c:if>
                                        </td>
                                        <td>${v.views}</td>
                                        <td class="small text-secondary"><c:out value="${v.createdDate}"/></td>
                                        <td class="text-end text-nowrap">
                                            <a href="${pageContext.request.contextPath}/video/detail?id=${v.videoId}" class="btn btn-sm btn-ghost">Xem</a>
                                            <a href="${pageContext.request.contextPath}/video/edit?id=${v.videoId}" class="btn btn-sm btn-ah">Sửa</a>
                                            <a href="${pageContext.request.contextPath}/video/delete?id=${v.videoId}"
                                               class="btn btn-sm btn-outline-danger"
                                               onclick="return confirm('Bạn có chắc muốn xóa video này?');">Xóa</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <c:if test="${totalPages > 1}">
                    <nav aria-label="Phân trang video" class="mt-4 d-flex justify-content-center">
                        <ul class="pagination app-pagination mb-0">
                            <c:if test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="${pageContext.request.contextPath}/video?page=${currentPage - 1}">Trước</a>
                                </li>
                            </c:if>
                            <c:forEach begin="1" end="${totalPages}" var="p">
                                <li class="page-item ${p == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/video?page=${p}">${p}</a>
                                </li>
                            </c:forEach>
                            <c:if test="${currentPage < totalPages}">
                                <li class="page-item">
                                    <a class="page-link" href="${pageContext.request.contextPath}/video?page=${currentPage + 1}">Sau</a>
                                </li>
                            </c:if>
                        </ul>
                    </nav>
                </c:if>
            </c:otherwise>
        </c:choose>
    </div>
</section>
</body>
</html>
