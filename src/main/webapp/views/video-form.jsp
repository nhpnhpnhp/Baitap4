<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="isEdit" value="${video != null && video.videoId != null}"/>
<!doctype html>
<html lang="vi">
<head>
    <title>${isEdit ? 'Cập nhật Video' : 'Thêm Video mới'}</title>
</head>
<body>
<section class="app-section">
    <div class="container">
        <div class="app-form-wrap">
            <div class="app-card">
                <div class="app-card-header">
                    <span class="ah-eyebrow mb-2">Quản lý video</span>
                    <h1 class="h3 mb-1">${isEdit ? 'Cập nhật Video' : 'Thêm Video mới'}</h1>
                    <p class="mb-0 text-secondary">
                        ${isEdit ? 'Chỉnh sửa thông tin hoặc thay thế file video hiện tại.' : 'Điền thông tin và tải lên file video (.mp4, .webm, .ogg, .mov, tối đa 50MB).'}
                    </p>
                </div>
                <div class="app-card-body">
                    <c:if test="${alert != null}">
                        <div class="alert app-alert-danger mb-3" role="alert">
                            <c:out value="${alert}"/>
                        </div>
                    </c:if>

                    <form method="post"
                          action="${pageContext.request.contextPath}${isEdit ? '/video/update' : '/video/insert'}"
                          enctype="multipart/form-data"
                          novalidate>
                        <c:if test="${isEdit}">
                            <input type="hidden" name="videoId" value="<c:out value='${video.videoId}'/>">
                        </c:if>

                        <div class="mb-3">
                            <label for="title" class="form-label">Tiêu đề video <span class="text-danger">*</span></label>
                            <input type="text"
                                   id="title"
                                   name="title"
                                   value="<c:out value='${video.title}'/>"
                                   placeholder="Nhập tiêu đề video"
                                   class="form-control ${not empty errors.title ? 'is-invalid' : ''}">
                            <c:if test="${not empty errors.title}">
                                <div class="invalid-feedback"><c:out value="${errors.title}"/></div>
                            </c:if>
                        </div>

                        <div class="mb-3">
                            <label for="description" class="form-label">Mô tả</label>
                            <textarea id="description"
                                      name="description"
                                      rows="4"
                                      placeholder="Mô tả ngắn về nội dung video (tối đa 500 ký tự)"
                                      class="form-control ${not empty errors.description ? 'is-invalid' : ''}"><c:out value="${video.description}"/></textarea>
                            <c:if test="${not empty errors.description}">
                                <div class="invalid-feedback"><c:out value="${errors.description}"/></div>
                            </c:if>
                        </div>

                        <div class="mb-3">
                            <label for="categoryId" class="form-label">Danh mục</label>
                            <select id="categoryId"
                                    name="categoryId"
                                    class="form-select ${not empty errors.categoryId ? 'is-invalid' : ''}">
                                <option value="">-- Không chọn --</option>
                                <c:forEach items="${categories}" var="c">
                                    <option value="${c.categoryid}"
                                        ${(video.category != null && video.category.categoryid == c.categoryid) || (selectedCategoryId != null && selectedCategoryId == c.categoryid.toString()) ? 'selected' : ''}>
                                        <c:out value="${c.categoryname}"/>
                                    </option>
                                </c:forEach>
                            </select>
                            <c:if test="${not empty errors.categoryId}">
                                <div class="invalid-feedback"><c:out value="${errors.categoryId}"/></div>
                            </c:if>
                        </div>

                        <div class="mb-3">
                            <label class="form-label d-block">Trạng thái</label>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input ${not empty errors.active ? 'is-invalid' : ''}"
                                       type="radio"
                                       id="activeOn"
                                       name="active"
                                       value="1"
                                       ${video == null || video.active == 1 ? 'checked' : ''}>
                                <label class="form-check-label" for="activeOn">Hoạt động</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input ${not empty errors.active ? 'is-invalid' : ''}"
                                       type="radio"
                                       id="activeOff"
                                       name="active"
                                       value="0"
                                       ${video != null && video.active == 0 ? 'checked' : ''}>
                                <label class="form-check-label" for="activeOff">Ẩn</label>
                            </div>
                            <c:if test="${not empty errors.active}">
                                <div class="invalid-feedback d-block"><c:out value="${errors.active}"/></div>
                            </c:if>
                        </div>

                        <div class="mb-4">
                            <label for="videoFile" class="form-label">
                                File video (.mp4, .webm, .ogg, .mov)
                                <c:if test="${!isEdit}"><span class="text-danger">*</span></c:if>
                            </label>
                            <c:if test="${isEdit && not empty video.videoPath}">
                                <div class="form-text mb-2">
                                    File hiện tại: <strong class="text-white"><c:out value="${video.videoPath}"/></strong> (bỏ trống nếu giữ nguyên).
                                </div>
                            </c:if>
                            <input type="file"
                                   id="videoFile"
                                   name="videoFile"
                                   accept="video/mp4,video/webm,video/ogg,video/quicktime"
                                   class="form-control ${not empty errors.videoFile ? 'is-invalid' : ''}">
                            <c:if test="${not empty errors.videoFile}">
                                <div class="invalid-feedback"><c:out value="${errors.videoFile}"/></div>
                            </c:if>
                            <div class="form-text">Dung lượng tối đa 50MB.</div>
                        </div>

                        <div class="d-flex flex-wrap gap-2">
                            <button type="submit" class="btn btn-ah">${isEdit ? 'Cập nhật' : 'Upload & Lưu'}</button>
                            <a href="${pageContext.request.contextPath}/video" class="btn btn-ghost">Hủy</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</section>
</body>
</html>
