<%-- 
    Document   : footerS
    Created on : 20 Jun 2026, 1:13:30 pm
    Author     : ASUS
--%>

<%@ page pageEncoding="UTF-8" %>
</div>
<!-- End of container -->

<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- Custom JavaScript -->
<script src="${pageContext.request.contextPath}/js/validation.js"></script>

<script>
    // Auto dismiss alerts after 5 seconds
    document.addEventListener('DOMContentLoaded', function() {
        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(function(alert) {
            setTimeout(function() {
                const closeBtn = alert.querySelector('.btn-close');
                if (closeBtn) {
                    closeBtn.click();
                }
            }, 5000);
        });
    });
</script>
</body>
</html>