<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="vi">
<head>
    <title>Quản lý danh mục</title>
</head>
<body>
<section class="app-page-header">
    <div class="container">
        <div class="d-flex flex-wrap justify-content-between align-items-end gap-3">
            <div>
                <span class="ah-eyebrow mb-2">Quản trị</span>
                <h1 class="h2 mb-0">Danh sách danh mục</h1>
            </div>
            <a href="<c:url value='/admin/category/add'/>" class="btn btn-ah">+ Thêm danh mục</a>
        </div>
    </div>
</section>
<section class="app-section">
    <div class="container">
        <div class="app-card overflow-hidden">
            <div class="table-responsive">
                <table class="table table-hover align-middle app-table">
                    <thead>
                        <tr>
                            <th>STT</th>
                            <th>Hình ảnh</th>
                            <th>Tên danh mục</th>
                            <th>Trạng thái</th>
                            <th class="text-end">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${listcate}" var="cate" varStatus="STT">
                            <tr>
                                <td>${STT.index + 1}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${cate.images != null && cate.images.startsWith('https')}">
                                            <c:url value="${cate.images}" var="imgUrl"/>
                                        </c:when>
                                        <c:otherwise>
                                            <c:url value="/image?fname=${cate.images}" var="imgUrl"/>
                                        </c:otherwise>
                                    </c:choose>
                                    <img height="70" width="100" class="rounded object-fit-cover" src="${imgUrl}" alt="<c:out value='${cate.categoryname}'/>"/>
                                </td>
                                <td class="text-white fw-semibold"><c:out value="${cate.categoryname}"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${cate.status == 1}">
                                            <span class="badge bg-success bg-opacity-25 text-success">Hoạt động</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary bg-opacity-25 text-secondary">Khóa</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-end text-nowrap">
                                    <a href="<c:url value='/admin/category/edit?id=${cate.categoryid}'/>" class="btn btn-sm btn-ah">Sửa</a>
                                    <a href="<c:url value='/admin/category/delete?id=${cate.categoryid}'/>" class="btn btn-sm btn-outline-danger">Xóa</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</section>
</body>
</html>
