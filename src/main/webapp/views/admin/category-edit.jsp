<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="vi">
<head>
    <title>Cập nhật danh mục</title>
</head>
<body>
<section class="app-section">
    <div class="container">
        <div class="app-form-wrap">
            <div class="app-card">
                <div class="app-card-header">
                    <span class="ah-eyebrow mb-2">Quản trị</span>
                    <h1 class="h3 mb-0">Cập nhật danh mục</h1>
                </div>
                <div class="app-card-body">
                    <form action="<c:url value='/admin/category/update'/>" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="categoryid" value="${cate.categoryid}">
                        <div class="mb-3">
                            <label for="categoryname" class="form-label">Tên danh mục</label>
                            <input type="text" id="categoryname" name="categoryname" value="<c:out value='${cate.categoryname}'/>" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label for="images" class="form-label">Link hình ảnh</label>
                            <input type="text" id="images" name="images" value="<c:out value='${cate.images}'/>" class="form-control">
                        </div>
                        <div class="mb-3">
                            <c:choose>
                                <c:when test="${cate.images != null && cate.images.startsWith('https')}">
                                    <c:url value="${cate.images}" var="imgUrl"/>
                                </c:when>
                                <c:otherwise>
                                    <c:url value="/image?fname=${cate.images}" var="imgUrl"/>
                                </c:otherwise>
                            </c:choose>
                            <img height="120" width="160" class="rounded object-fit-cover border border-secondary" src="${imgUrl}" alt=""/>
                        </div>
                        <div class="mb-3">
                            <label for="images1" class="form-label">Upload hình ảnh mới</label>
                            <input type="file" id="images1" name="images1" class="form-control">
                        </div>
                        <div class="mb-4">
                            <label class="form-label d-block">Trạng thái</label>
                            <div class="form-check form-check-inline">
                                <input type="radio" id="ston" name="status" value="1" class="form-check-input" ${cate.status == 1 ? 'checked' : ''}>
                                <label for="ston" class="form-check-label">Hoạt động</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input type="radio" id="stoff" name="status" value="0" class="form-check-input" ${cate.status != 1 ? 'checked' : ''}>
                                <label for="stoff" class="form-check-label">Khóa</label>
                            </div>
                        </div>
                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-ah">Cập nhật</button>
                            <a href="<c:url value='/admin/categories'/>" class="btn btn-ghost">Hủy</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</section>
</body>
</html>
