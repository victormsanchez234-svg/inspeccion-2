<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title> inspectores </title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="css/estilos.css" rel="stylesheet" type="text/css" />
<link href="imagenes/faviconhor.png" rel="shortcut icon" type="image/png">

<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

<style>
    .modal-overlay {
        display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%;
        background-color: rgba(0, 0, 0, 0.8); z-index: 9999;
        justify-content: center; align-items: center; backdrop-filter: blur(5px);
    }
    .modal-content-large {
        background-color: #0f172a; width: 95%; max-width: 800px; /* Más ancho para el perfil */
        border-radius: 16px; padding: 30px; border: 1px solid #334155;
        box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
    }
    .close-modal-btn { position: absolute; top: 15px; right: 20px; font-size: 1.5rem; color: #94a3b8; cursor: pointer; }
</style>
</head>

<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%
if (session.getAttribute("cve_usuarios") == null) { response.sendRedirect("login.jsp"); return; }
%>

<body>

<div class="dashboard-container">

    <header class="dashboard-header">
        <h1>Gestión de Inspectores</h1>
        <div class="header-user-info">
             <span>Usuario: <%= session.getAttribute("usuario") %></span>
             <a href="dashboard.jsp" class="btn-salir" style="margin-left:10px;">VOLVER</a>
        </div>
    </header>

    <div class="view-tabs">
        <button class="tab-btn active" onclick="switchView('list')">Listado de Personal</button>
        <button class="tab-btn" onclick="switchView('schedule')">Programación y Carga</button>
    </div>

    <div id="view-list">
        <div class="toolbar" style="display: flex; justify-content: space-between; margin-bottom: 20px;">
            <div class="search-wrapper" style="flex-grow: 1; max-width: 400px; position: relative;">
                <i class="fa-solid fa-search" style="position: absolute; left: 15px; top: 12px; color: #94a3b8;"></i>
                 <input type="text" style="width: 100%; padding: 10px 10px 10px 40px; background:#1e293b; border:1px solid #334155; border-radius:8px; color:white;" placeholder="Buscar inspector...">
            </div>
           <button class="action-button" onclick="openAddModal()" style="background-color: #ffab00; color: white; border:none; cursor: pointer;">
    + Agregar Inspector
</button>
        </div>

        <div class="table-container">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Avatar</th>
                        <th>Nombre</th>
                        <th>ID / Gafete</th>
                        <th>Estado Actual</th>
                        <th>Tarea Asignada</th>
                        <th style="text-align: center;">Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <tr style="cursor: pointer;" onclick="openProfileModal('Victor Sanchez', 'Disponible')">
                        <td><img src="assets/img/avatar1.jpg" class="avatar-small" alt="Foto"></td> <td><strong>Victor Sanchez</strong></td>
                        <td>1220161910</td>
                        <td><span class="badge-status status-disponible">Disponible</span></td>
                        <td>-</td>
                        <td style="text-align: center;" onclick="event.stopPropagation()"> <a href="#" style="color:#3b82f6; margin-right:10px;"><i class="fa-solid fa-pen"></i></a>
                            <a href="#" style="color:#ef4444;"><i class="fa-solid fa-trash"></i></a>
                        </td>
                    </tr>
                    <tr>
                        <td><img src="https://i.pravatar.cc/150?img=3" class="avatar-small" alt="Foto"></td>
                        <td>Mark Lennez</td>
                        <td>1220189934</td>
                        <td><span class="badge-status status-ocupado">En Inspección</span></td>
                        <td>Plaza Crystal (Acta #5501)</td>
                        <td style="text-align: center;">
                            <a href="#" style="color:#3b82f6; margin-right:10px;"><i class="fa-solid fa-pen"></i></a>
                            <a href="#" style="color:#ef4444;"><i class="fa-solid fa-trash"></i></a>
                        </td>
                    </tr>
                     <tr>
                        <td><img src="https://i.pravatar.cc/150?img=8" class="avatar-small" alt="Foto"></td>
                        <td>Michel Juarez</td>
                        <td>1220191247</td>
                        <td><span class="badge-status status-inactivo">Inactivo</span></td>
                        <td>Incapacidad Médica</td>
                        <td style="text-align: center;">
                            <a href="#" style="color:#3b82f6; margin-right:10px;"><i class="fa-solid fa-pen"></i></a>
                            <a href="#" style="color:#ef4444;"><i class="fa-solid fa-trash"></i></a>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

   <div id="view-schedule" style="display: none;">
        
        <div class="schedule-toolbar">
            <div style="color: #94a3b8; font-weight: 600;">
                <i class="fa-regular fa-calendar" style="margin-right: 8px;"></i>
                Jueves, 12 de Febrero 2026
            </div>
            <div style="display: flex; gap: 10px;">
                <button class="action-button" style="background:#334155; border:none; color:white; cursor:pointer;">Hoy</button>
                <button class="action-button" onclick="openAssignModal()" style="background-color: #ffab00; color: white; border:none; cursor: pointer;">
                    <i class="fa-solid fa-plus"></i> Nueva Asignación
                </button>
            </div>
        </div>

        <div class="schedule-container">
            <div class="timeline-header header-empty">Inspector</div>
            <div class="timeline-header">09:00</div>
            <div class="timeline-header">10:00</div>
            <div class="timeline-header">11:00</div>
            <div class="timeline-header">12:00</div>
            <div class="timeline-header">13:00</div>
            <div class="timeline-header">14:00</div>
            <div class="timeline-header">15:00</div>
            <div class="timeline-header">16:00</div>

            <div class="inspector-row-label" style="grid-row: 2;">Victor Sanchez</div>
            <div class="timeline-bg-layer" style="grid-row: 2;">
                <div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div>
            </div>
            <div class="task-block task-green" style="grid-column: 2 / span 2; grid-row: 2;">
                Insp. #1234 - Plaza Las Américas
            </div>
            <div class="task-block task-blue" style="grid-column: 6 / span 2; grid-row: 2;">
                Insp. #1235 - Revisión Activos
            </div>

            <div class="inspector-row-label" style="grid-row: 3;">Mark Lennez</div>
            <div class="timeline-bg-layer" style="grid-row: 3;">
                <div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div>
            </div>
            <div class="task-block task-red" style="grid-column: 2 / span 3; grid-row: 3;">
                Insp. #1232 - Tarea Crítica
            </div>

            <div class="inspector-row-label" style="grid-row: 4;">Michel Juarez</div>
            <div class="timeline-bg-layer" style="grid-row: 4;">
                <div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div>
            </div>
            <div class="task-block task-orange" style="grid-column: 7 / span 1; grid-row: 4;">
                Insp. #1240 - Seguimiento
            </div>

            <div class="empty-row-label" style="grid-row: 5;"></div>
            <div class="timeline-bg-layer" style="grid-row: 5;">
                <div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div>
            </div>

            <div class="empty-row-label" style="grid-row: 6;"></div>
            <div class="timeline-bg-layer" style="grid-row: 6;">
                <div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div>
            </div>

             <div class="empty-row-label" style="grid-row: 7;"></div>
             <div class="timeline-bg-layer" style="grid-row: 7;">
                 <div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div>
             </div>
             
             <div class="empty-row-label" style="grid-row: 8;"></div>
             <div class="timeline-bg-layer" style="grid-row: 8;">
                 <div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div>
             </div>
        </div>
    </div>

</div> <div id="modal-profile" class="modal-overlay">
    <div class="modal-content-large" style="position: relative;">
        <i class="fa-solid fa-xmark close-modal-btn" onclick="closeProfileModal()"></i>
        
        <h2 style="color: white; margin-top: 0; margin-bottom: 25px;">Detalles del Inspector</h2>
        
        <div class="profile-layout">
            <div class="profile-left">
                <img src="assets/img/avatar1.jpg" class="avatar-large" id="modal-avatar" alt="Foto Perfil">
                <h2 style="margin: 10px 0; color:white;" id="modal-name">Nombre Inspector</h2>
                
                <div class="profile-info">
                    <p>ID: 1220161910</p>
                    <p>Tel: 993 123 4567</p>
                    <p>Email: inspector@email.com</p>
                </div>
                
                <div style="margin-top: 25px;">
                    <span class="badge-status status-disponible" style="font-size: 1rem; padding: 10px 30px;" id="modal-status">Disponible</span>
                </div>
            </div>

            <div class="profile-right">
                <h3 style="color: #cbd5e1; margin-top: 0;">Ubicación Actual</h3>
                <div class="mini-map-container">
                    <div id="mini-map" style="width: 100%; height: 100%;"></div>
                </div>

                <h3 style="color: #cbd5e1;">Asignaciones en Curso</h3>
                <div class="assignments-box">
                    <div class="assignment-item">
                        <strong style="color:white;">Inspección #1234 - Plaza Las Américas</strong><br>
                        <span style="color:#94a3b8; font-size:0.85rem;">Iniciada: Hoy, 09:15 AM</span>
                    </div>
                    <div class="assignment-item" style="border-left-color: #f59e0b;"> <strong style="color:white;">Reporte Pendiente #551</strong><br>
                        <span style="color:#94a3b8; font-size:0.85rem;">Vence: Mañana</span>
                    </div>
                </div>
            </div>
        </div> <div style="text-align: right; margin-top: 20px;">
             <button class="tab-btn" style="background:#334155; color:white; border-radius:6px;" onclick="closeProfileModal()">Cerrar</button>
        </div>
    </div>
</div>


<div id="modal-add-inspector" class="modal-overlay">
    <div class="modal-content-large" style="max-width: 500px;">
        <h2 style="color: white; margin-top: 0;">Registrar Nuevo Inspector</h2>
        <hr style="border: 0; border-top: 1px solid #334155; margin-bottom: 20px;">
        
        <form id="form-new-inspector">
            <div style="margin-bottom: 15px;">
                <label style="color: #94a3b8; display: block; margin-bottom: 5px;">Nombre Completo</label>
                <input type="text" style="width: 100%; padding: 10px; background: #1e293b; border: 1px solid #334155; color: white; border-radius: 6px;" placeholder="Ej. Juan Pérez">
            </div>

            <div style="margin-bottom: 15px;">
                <label style="color: #94a3b8; display: block; margin-bottom: 5px;">ID / Gafete</label>
                <input type="text" style="width: 100%; padding: 10px; background: #1e293b; border: 1px solid #334155; color: white; border-radius: 6px;" placeholder="Ej. 1220...">
            </div>

            <div style="margin-bottom: 25px;">
                <label style="color: #94a3b8; display: block; margin-bottom: 5px;">Estado Inicial</label>
                <select style="width: 100%; padding: 10px; background: #1e293b; border: 1px solid #334155; color: white; border-radius: 6px;">
                    <option value="Disponible">Disponible</option>
                    <option value="Inactivo">Inactivo</option>
                </select>
            </div>

            <div style="text-align: right; display: flex; gap: 10px; justify-content: flex-end;">
                <button type="button" onclick="closeAddModal()" style="background: #334155; color: white; border: none; padding: 10px 20px; border-radius: 6px; cursor: pointer;">Cancelar</button>
                <button type="button" onclick="alert('Guardado exitosamente (Simulación)')" style="background: #ffab00; color: white; border: none; padding: 10px 20px; border-radius: 6px; font-weight: bold; cursor: pointer;">Guardar</button>
            </div>
        </form>
    </div>
</div>

<div id="modal-assign-task" class="modal-overlay">
    <div class="modal-content-large" style="max-width: 500px;">
        <h2 style="color: white; margin-top: 0;">Programar Inspección</h2>
        <hr style="border: 0; border-top: 1px solid #334155; margin-bottom: 20px;">
        
        <form>
            <div class="form-group">
                <label class="form-label">Seleccionar Inspector</label>
                <select class="form-control">
                    <option>Victor Sanchez</option>
                    <option>Mark Lennez</option>
                    <option>Michel Juarez</option>
                </select>
            </div>

            <div class="form-group">
                <label class="form-label">Asunto / Tarea</label>
                <input type="text" class="form-control" placeholder="Ej. Inspección Anual - Plaza Altabrisa">
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                <div class="form-group">
                    <label class="form-label">Hora Inicio</label>
                    <input type="time" class="form-control" value="09:00">
                </div>
                <div class="form-group">
                    <label class="form-label">Duración (Horas)</label>
                    <input type="number" class="form-control" value="2">
                </div>
            </div>

            <div class="form-group">
                <label class="form-label">Prioridad (Color)</label>
                <select class="form-control">
                    <option value="green">Normal (Verde)</option>
                    <option value="blue">Informativa (Azul)</option>
                    <option value="orange">Seguimiento (Naranja)</option>
                    <option value="red">Urgente (Rojo)</option>
                </select>
            </div>

            <div class="form-actions">
                <button type="button" class="btn-cancel" onclick="closeAssignModal()">Cancelar</button>
                <button type="button" class="btn-save" onclick="alert('Asignación guardada')">Asignar</button>
            </div>
        </form>
    </div>
</div>


<script>
    // Variables globales
    var miniMap = null;

    // --- 1. PESTAÑAS (Listado vs Programación) ---
    function switchView(viewName) {
        // Ocultamos ambas vistas
        document.getElementById('view-list').style.display = 'none';
        document.getElementById('view-schedule').style.display = 'none';
        
        // Quitamos la clase 'active' de los botones
        var tabs = document.querySelectorAll('.tab-btn');
        tabs.forEach(btn => btn.classList.remove('active'));

        if (viewName === 'list') {
            document.getElementById('view-list').style.display = 'block';
            tabs[0].classList.add('active'); // Activa el primer botón
        } else {
            document.getElementById('view-schedule').style.display = 'block';
            tabs[1].classList.add('active'); // Activa el segundo botón
        }
    }

    // --- 2. MODAL: AGREGAR INSPECTOR ---
    function openAddModal() {
        document.getElementById('modal-add-inspector').style.display = 'flex';
    }
    function closeAddModal() {
        document.getElementById('modal-add-inspector').style.display = 'none';
    }

    // --- 3. MODAL: PERFIL DE INSPECTOR (Al hacer clic en la fila) ---
    function openProfileModal(name, status) {
        // Asignamos los datos al modal
        document.getElementById('modal-name').innerText = name;
        var statusBadge = document.getElementById('modal-status');
        statusBadge.innerText = status;
        
        // Cambiamos el color del badge según el estado
        statusBadge.className = 'badge-status'; // Reset de clases
        if(status === 'Disponible') statusBadge.classList.add('status-disponible');
        else if(status === 'En Inspección') statusBadge.classList.add('status-ocupado');
        else statusBadge.classList.add('status-inactivo');

        // Mostramos el modal
        document.getElementById('modal-profile').style.display = 'flex';
        
        // Inicializamos el mapa (con un pequeño retraso para que cargue bien)
        setTimeout(function() {
            if (!miniMap) {
                // Si no existe el mapa, lo creamos
                miniMap = L.map('mini-map', {zoomControl: false}).setView([17.99, -92.94], 14);
                L.tileLayer('https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png', { attribution: '' }).addTo(miniMap);
                L.marker([17.99, -92.94]).addTo(miniMap);
            } else {
                // Si ya existe, solo ajustamos su tamaño
                miniMap.invalidateSize();
            }
        }, 200);
    }

    function closeProfileModal() {
        document.getElementById('modal-profile').style.display = 'none';
    }

    // --- 4. CERRAR MODALES AL DAR CLIC FUERA ---
    window.onclick = function(event) {
        var modalProfile = document.getElementById('modal-profile');
        var modalAdd = document.getElementById('modal-add-inspector');
        
        if (event.target == modalProfile) closeProfileModal();
        if (event.target == modalAdd) closeAddModal();
    }

    // --- 5. MODAL: NUEVA ASIGNACIÓN ---
    function openAssignModal() {
        document.getElementById('modal-assign-task').style.display = 'flex';
    }
    
    function closeAssignModal() {
        document.getElementById('modal-assign-task').style.display = 'none';
    }
    
    // Agregar al cierre global (window.onclick)
    // Busca tu función window.onclick existente y agrega esta línea dentro:
    // if (event.target == document.getElementById('modal-assign-task')) closeAssignModal();
</script>

</body>
</html>