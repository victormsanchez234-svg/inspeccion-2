<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title> actas </title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="css/estilos.css" rel="stylesheet" type="text/css" />
<link href="imagenes/faviconhor.png" rel="shortcut icon" type="image/png">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

<style>
    .modal-overlay {
        display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%;
        background-color: rgba(0, 0, 0, 0.8); z-index: 9999;
        justify-content: center; align-items: center; backdrop-filter: blur(5px);
    }
    /* Modal de Carga (ancho normal) */
    #modal-new-acta .modal-content {
        background-color: #1e293b; width: 90%; max-width: 500px;
        border-radius: 16px; padding: 30px; border: 1px solid #334155;
        box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
    }
    /* Modal de Detalle (muy ancho para el preview) */
    #modal-detail-acta .modal-content-xl {
        background-color: #1e293b; width: 95%; max-width: 1100px;
        border-radius: 16px; padding: 30px; border: 1px solid #334155;
        box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
        position: relative; /* Para el botón de cerrar */
    }
    .close-modal-btn { position: absolute; top: 20px; right: 25px; font-size: 1.5rem; color: #94a3b8; cursor: pointer; z-index: 10; }
</style>
</head>

<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%
if (session.getAttribute("cve_usuarios") == null) { response.sendRedirect("login.jsp"); return; }
%>

<body>

<div class="dashboard-container">

    <header class="dashboard-header">
        <h1>Gestión de Actas</h1>
        <div class="header-user-info">
             <span>Usuario: <%= session.getAttribute("usuario") %></span>
              <a href="dashboard.jsp" class="btn-salir" style="margin-left:10px;">VOLVER</a>
        </div>
    </header>

    <div id="view-list">
        <div class="toolbar" style="display: flex; justify-content: space-between; margin-bottom: 20px;">
            <div class="search-wrapper" style="flex-grow: 1; max-width: 400px; position: relative;">
                <i class="fa-solid fa-search" style="position: absolute; left: 15px; top: 12px; color: #94a3b8;"></i>
                 <input type="text" style="width: 100%; padding: 10px 10px 10px 40px; background:#1e293b; border:1px solid #334155; border-radius:8px; color:white;" placeholder="Buscar por No. Acta, Inmueble...">
            </div>
            <button class="action-button" onclick="openNewActaModal()" style="background-color: #ffab00; color: white; border:none; cursor: pointer;">
                + Nueva Acta
            </button>
        </div>

        <div class="table-container">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>No. Acta</th>
                        <th>Inmueble Inspeccionado</th>
                        <th>Fecha</th>
                        <th>Inspector</th>
                        <th>Estado</th>
                        <th style="text-align: center;">Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <tr style="cursor: pointer;" onclick="openDetailModal('1234', 'Plaza Las Américas', '31/01/2022', 'Victor Sanchez', 'aprobada')">
                        <td>#1234</td>
                        <td>Insp. #1234 - Plaza Las Américas</td>
                        <td>31/01/2022</td>
                        <td>Victor Sanchez</td>
                        <td><span class="badge-risk bg-bajo">Aprobada</span></td> 
                        <td style="text-align: center;" onclick="event.stopPropagation()"> <a href="#" style="color:#3b82f6; margin-right:10px;"><i class="fa-solid fa-pen"></i></a>
                            <a href="#" style="color:#ef4444;"><i class="fa-solid fa-trash"></i></a>
                        </td>
                    </tr>
                    <tr style="cursor: pointer;" onclick="openDetailModal('1236', 'Tarea Crítica', '20/01/2022', 'Mark Lennez', 'reprobada')">
                        <td>#1236</td>
                        <td>Insp. #1232 - Tarea Crítica</td>
                        <td>20/01/2022</td>
                        <td>Mark Lennez</td>
                        <td><span class="badge-risk bg-alto">Reprobada</span></td> 
                        <td style="text-align: center;" onclick="event.stopPropagation()">
                            <a href="#" style="color:#3b82f6; margin-right:10px;"><i class="fa-solid fa-pen"></i></a>
                            <a href="#" style="color:#ef4444;"><i class="fa-solid fa-trash"></i></a>
                        </td>
                    </tr>
                     <tr style="cursor: pointer;" onclick="openDetailModal('1239', 'Plaza Altabrisa', '05/02/2022', 'Michel Juarez', 'pendiente')">
                        <td>#1239</td>
                        <td>Insp. #13321 - Plaza Altabrisa</td>
                        <td>05/02/2022</td>
                        <td>Michel Juarez</td>
                        <td><span class="badge-risk bg-pendiente">Pendiente</span></td> 
                        <td style="text-align: center;" onclick="event.stopPropagation()">
                            <a href="#" style="color:#3b82f6; margin-right:10px;"><i class="fa-solid fa-pen"></i></a>
                            <a href="#" style="color:#ef4444;"><i class="fa-solid fa-trash"></i></a>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

</div> <div id="modal-new-acta" class="modal-overlay">
    <div class="modal-content">
        <h2 style="color: white; margin-top: 0;">Nueva Acta de Inspección</h2>
        <hr style="border: 0; border-top: 1px solid #334155; margin-bottom: 20px;">
        
        <form>
            <div class="form-group">
                <label class="form-label">Seleccionar Inmueble</label>
                <select class="form-control">
                    <option>Seleccionar Inmueble...</option>
                    <option>Plaza Las Américas</option>
                    <option>Escuela Benito Juárez</option>
                </select>
            </div>

            <div class="form-group">
                <label class="form-label">Fecha de Inspección</label>
                <input type="date" class="form-control">
            </div>
            
            <div class="form-group">
                <label class="form-label">Inspector Asignado</label>
                <select class="form-control">
                    <option>Seleccionar Inspector...</option>
                    <option>Victor Sanchez</option>
                    <option>Mark Lennez</option>
                </select>
            </div>

            <div class="form-group">
                <label class="form-label" style="margin-bottom:10px;">Documento del Acta</label>
                <div class="file-upload-area" onclick="document.getElementById('file-input').click()">
                    <i class="fa-solid fa-cloud-arrow-up file-upload-icon"></i>
                    <p style="margin: 0;">Clic para cargar documento (PDF/Imagen)</p>
                    <input type="file" id="file-input" style="display: none;">
                </div>
            </div>

            <div class="form-group">
                <label class="form-label">Estado Inicial</label>
                <select class="form-control">
                    <option value="pendiente">Pendiente</option>
                    <option value="aprobada">Aprobada</option>
                    <option value="reprobada">Reprobada</option>
                </select>
            </div>

            <div class="form-actions">
                <button type="button" class="btn-cancel" onclick="closeNewActaModal()">Cancelar</button>
                <button type="button" class="btn-save" onclick="alert('Acta guardada (Simulación)')">Guardar Acta</button>
            </div>
        </form>
    </div>
</div>


<div id="modal-detail-acta" class="modal-overlay">
    <div class="modal-content-xl">
        <i class="fa-solid fa-xmark close-modal-btn" onclick="closeDetailModal()"></i>
        
        <h2 style="color: white; margin-top: 0; margin-bottom: 20px;" id="detail-title">Detalles del Acta #</h2>
        
        <div class="detail-layout">
            
            <div class="detail-left-panel">
                <div class="detail-info-box">
                    <p><strong>Inmueble:</strong> <span id="detail-inmueble">-</span></p>
                    <p><strong>Fecha:</strong> <span id="detail-fecha">-</span></p>
                    <p><strong>Inspector:</strong> <span id="detail-inspector">-</span></p>
                </div>

                <div style="margin-top: 30px;">
                    <strong style="color:#94a3b8; display:block; margin-bottom:15px;">Estado Actual:</strong>
                    <div id="detail-status-badge" class="large-status-badge bg-bajo">Aprobada</div>
                </div>

                <div style="margin-top: auto; display: flex; flex-direction: column; gap: 15px;">
                    <button class="action-button" style="background-color: #ffab00; color: white; border:none; cursor: pointer; width: 100%; justify-content: center; font-size: 1rem; padding: 12px;">
                        <i class="fa-solid fa-file-pdf" style="margin-right: 10px;"></i> Descargar PDF
                    </button>
                    <button class="action-button" style="background-color: #334155; color: white; border:none; cursor: pointer; width: 100%; justify-content: center; font-size: 1rem; padding: 12px;">
                        Actualizar Estado
                    </button>
                </div>
            </div>

            <div class="detail-right-panel">
                <h3 style="color: #cbd5e1; margin-top: 0; margin-bottom: 15px;">Vista Previa del Documento</h3>
                <div class="document-preview-container">
                    <img src="https://placehold.co/400x550/1e293b/ffffff?text=Vista+Previa+del+Acta+(PDF/Imagen)" class="document-placeholder" alt="Preview del Documento">
                </div>
            </div>

        </div> </div>
</div>


<script>
    // --- 1. FUNCIONES DEL MODAL: NUEVA ACTA ---
    function openNewActaModal() {
        document.getElementById('modal-new-acta').style.display = 'flex';
    }
    function closeNewActaModal() {
        document.getElementById('modal-new-acta').style.display = 'none';
    }

    // --- 2. FUNCIONES DEL MODAL: DETALLE DEL ACTA ---
    // Esta función recibe los datos de la fila en la que se hizo clic
    function openDetailModal(id, inmueble, fecha, inspector, estado) {
        // Llenar los campos de texto
        document.getElementById('detail-title').innerText = 'Detalles del Acta #' + id;
        document.getElementById('detail-inmueble').innerText = inmueble;
        document.getElementById('detail-fecha').innerText = fecha;
        document.getElementById('detail-inspector').innerText = inspector;
        
        // Configurar el badge grande de estado
        var statusBadge = document.getElementById('detail-status-badge');
        // Reiniciar clases para quitar colores anteriores
        statusBadge.className = 'large-status-badge'; 
        
        if(estado === 'aprobada') {
            statusBadge.innerText = 'Aprobada';
            statusBadge.classList.add('bg-bajo'); // Verde
        } else if(estado === 'reprobada') {
            statusBadge.innerText = 'Reprobada';
            statusBadge.classList.add('bg-alto'); // Rojo
        } else {
            statusBadge.innerText = 'Pendiente';
            statusBadge.classList.add('bg-pendiente'); // Amarillo
        }

        // Mostrar el modal grande
        document.getElementById('modal-detail-acta').style.display = 'flex';
    }

    function closeDetailModal() {
        document.getElementById('modal-detail-acta').style.display = 'none';
    }

    // --- 3. CERRAR MODALES AL DAR CLIC FUERA ---
    window.onclick = function(event) {
        var modalNew = document.getElementById('modal-new-acta');
        var modalDetail = document.getElementById('modal-detail-acta');
        
        if (event.target == modalNew) closeNewActaModal();
        if (event.target == modalDetail) closeDetailModal();
    }
</script>

</body>
</html>