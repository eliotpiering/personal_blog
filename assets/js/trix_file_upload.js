(function() {
    var CREATE_DELETE_PATH = "/admin/uploads/"
    var SHOW_PATH = "/uploads/"


    addEventListener("trix-attachment-add", function(event) {
        if (event.attachment.file) {
            uploadFileAttachment(event.attachment)
        }
    })

    function uploadFileAttachment(attachment) {
        uploadFile(attachment.file, setProgress, setAttributes)

        function setProgress(progress) {
            attachment.setUploadProgress(progress)
        }

        function setAttributes(attributes) {
            attachment.setAttributes(attributes)
        }
    }

    function uploadFile(file, progressCallback, successCallback) {
        var key = createStorageKey(file)
        var formData = createFormData(key, file)
        var xhr = new XMLHttpRequest()

        xhr.open("POST", CREATE_DELETE_PATH, true)

        xhr.upload.addEventListener("progress", function(event) {
            var progress = event.loaded / event.total * 100
            progressCallback(progress)
        })

        xhr.addEventListener("load", function(event) {
            if (xhr.status == 204) {
                var attributes = {
                    url: SHOW_PATH + key,
                    href: SHOW_PATH + key + "?content-disposition=attachment"
                }
                successCallback(attributes)
            }
        })

        xhr.send(formData)
    }

    function createStorageKey(file) {
        var date = new Date()
        var day = date.toISOString().slice(0, 10)
        return date.getTime() + "-" + file.name
    }

    function createFormData(key, file) {
        var data = new FormData()
        data.append("title", key)
        data.append("Content-Type", file.type)
        data.append("file", file)
        data.append("post_id", getPostId())
        data.append("_csrf_token", getCsrfToken())
        return data
    }

    function getPostId() {
        var post_id_input = document.getElementById("post_id");
        return post_id_input ? post_id_input.value : null;
    }

    function getCsrfToken() {
        var token = document.getElementsByName("_csrf_token")[0];
        if (token && token.value) {
            return token.value;
        }
    };
})();