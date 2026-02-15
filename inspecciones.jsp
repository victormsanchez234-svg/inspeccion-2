<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title> inspecciones </title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="css/estilos.css?v=2" rel="stylesheet" type="text/css" />
<link href="imagenes/faviconhor.png" rel="shortcut icon" type="image/png">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>

<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%
if (session.getAttribute("cve_usuarios") == null) { response.sendRedirect("login.jsp"); return; }
%>

<body>

<div class="dashboard-container">

    <header class="dashboard-header">
        <h1>Tablero de Operaciones de Inspección</h1>
        <div class="header-user-info">
             <button class="action-button" onclick="openWizard()" ... >
    + Nueva Solicitud (Wizard)
</button>
             <span>Usuario: <%= session.getAttribute("usuario") %></span>
             <a href="dashboard.jsp" class="btn-salir" style="margin-left:10px;">VOLVER</a>
        </div>
    </header>

    <div class="kanban-board">
        
        <div class="kanban-column">
            <div class="kanban-header header-pendientes">Solicitudes Pendientes (2)</div>
            <div class="kanban-content">
                <div class="kanban-card">
                    <div class="card-title">Denuncia: Abarrotes La Esquina</div>
                    <div class="card-meta"><i class="fa-regular fa-calendar"></i> Sin fecha asignada</div>
                    <div class="card-footer">
                        <div style="color: #94a3b8; font-size: 0.85rem;">Sin inspector</div>
                        <span class="badge-risk bg-alto">Alto Riesgo</span>
                    </div>
                </div>
                <div class="kanban-card">
                    <div class="card-title">Ordinaria: Farmacia Guadalajara</div>
                    <div class="card-meta"><i class="fa-regular fa-clock"></i> Solicitada hace 2 días</div>
                    <div class="card-footer">
                        <div style="color: #94a3b8; font-size: 0.85rem;">Sin inspector</div>
                        <span class="badge-risk bg-bajo">Bajo Riesgo</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="kanban-column">
            <div class="kanban-header header-programadas">Programadas (3)</div>
            <div class="kanban-content">
                <div class="kanban-card">
                    <div class="card-title">Insp. #1245 - Plaza Las Américas</div>
                    <div class="card-meta"><i class="fa-regular fa-calendar-days"></i> 15/02/2026 - 10:00 AM</div>
                    <div class="card-footer">
                        <div class="inspector-info">
                            <img src="https://i.pravatar.cc/150?img=12" class="inspector-avatar-mini"> Victor Sanchez
                        </div>
                        <span class="badge-risk bg-medio">Medio</span>
                    </div>
                </div>
                 <div class="kanban-card">
                    <div class="card-title">Insp. #1248 - Escuela Benito Juárez</div>
                    <div class="card-meta"><i class="fa-regular fa-calendar-days"></i> 16/02/2026 - 09:00 AM</div>
                    <div class="card-footer">
                        <div class="inspector-info">
                            <img src="https://i.pravatar.cc/150?img=3" class="inspector-avatar-mini"> Mark Lennez
                        </div>
                        <span class="badge-risk bg-bajo">Bajo</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="kanban-column">
            <div class="kanban-header header-en-curso">
                En Curso <i class="fa-solid fa-tower-broadcast fa-beat" style="margin-left:8px;"></i>
            </div>
            <div class="kanban-content">
                <div class="kanban-card card-active">
                    <div class="card-title">Insp. #1242 - Cinepolis VIP</div>
                    <div class="card-meta" style="color:#f59e0b;"><i class="fa-solid fa-location-dot"></i> Inspector en sitio ahora</div>
                    <div class="card-footer">
                        <div class="inspector-info">
                            <img src="https://i.pravatar.cc/150?img=8" class="inspector-avatar-mini"> Michel Juarez
                        </div>
                        <button style="background:#f59e0b; border:none; color:black; padding:5px 10px; border-radius:4px; font-weight:bold; cursor:pointer; font-size:0.8rem;">Ver en Mapa</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="kanban-column">
            <div class="kanban-header header-realizadas">Realizadas / Por Dictaminar (2)</div>
            <div class="kanban-content">
                <div class="kanban-card" style="opacity: 0.8;"> <div class="card-title">Insp. #1240 - Restaurante Los Tulipanes</div>
                    <div class="card-meta"><i class="fa-solid fa-check-double"></i> Finalizada ayer, 14:30 PM</div>
                    <div class="card-footer">
                        <div class="inspector-info">
                            <img src="https://i.pravatar.cc/150?img=12" class="inspector-avatar-mini"> Victor Sanchez
                        </div>
                        <button style="background:#10b981; border:none; color:white; padding:5px 10px; border-radius:4px; cursor:pointer; font-size:0.8rem;">Generar Acta</button>
                    </div>
                </div>
            </div>
        </div>

    </div> </div>


<div id="modal-wizard" class="modal-overlay">
    <div class="modal-content" style="max-width: 850px; padding: 40px;">
        
        <h2 style="color: white; margin-top: 0; text-align: center; margin-bottom: 30px;">Nueva Inspección</h2>
        
        <div class="wizard-progress-modern">
            <div class="progress-bar-fill" id="progress-fill" style="width: 0%;"></div>
            <div class="progress-step-m step-active-m" id="p-step-1">
                <div class="step-circle-m">1</div>
                <div class="step-label-m">Inmueble y Motivo</div>
            </div>
            <div class="progress-step-m" id="p-step-2">
                <div class="step-circle-m">2</div>
                <div class="step-label-m">Inspector y Fecha</div>
            </div>
            <div class="progress-step-m" id="p-step-3">
                <div class="step-circle-m">3</div>
                <div class="step-label-m">Confirmar</div>
            </div>
        </div>

        <form id="form-wizard">
            <div class="wizard-grid">
                
                <div class="wizard-main-col">
                    
                    <div class="wizard-step-content active" id="step-1">
                        <div class="form-group">
                            <label class="form-label">Seleccionar Inmueble</label>
                            <select class="form-control" id="input-inmueble" onchange="updateSummary()">
                                <option value="">-- Seleccione --</option>
                                <option>Plaza Las Américas</option>
                                <option>Escuela Benito Juárez</option>
                                <option>Cinepolis VIP</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Motivo</label>
                            <select class="form-control" id="input-motivo" onchange="updateSummary()">
                                <option>Inspección Anual</option>
                                <option>Denuncia Ciudadana</option>
                                <option>Seguimiento</option>
                            </select>
                        </div>
                    </div>

                    <div class="wizard-step-content" id="step-2">
                        
                        <span class="avatar-selector-label">Seleccionar un Inspector</span>
                        <div class="avatar-list">
                            <div class="avatar-option" onclick="selectInspector(this, 'Victor Sanchez')">
                                <div class="avatar-img-wrapper">
                                    <img src="https://i.pravatar.cc/150?img=12">
                                </div>
                                <span class="avatar-name">Victor Sanchez</span>
                                <span class="avatar-status" style="color:#10b981;">Disponible</span>
                            </div>
                            <div class="avatar-option" onclick="selectInspector(this, 'Mark Lennez')">
                                <div class="avatar-img-wrapper">
                                    <img src="https://i.pravatar.cc/150?img=3">
                                </div>
                                <span class="avatar-name">Mark Lennez</span>
                                <span class="avatar-status" style="color:#f59e0b;">Ocupado</span>
                            </div>
                             <div class="avatar-option" onclick="selectInspector(this, 'Michel Juarez')">
                                <div class="avatar-img-wrapper">
                                    <img src="https://i.pravatar.cc/150?img=8">
                                </div>
                                <span class="avatar-name">Michel Juarez</span>
                                <span class="avatar-status" style="color:#ef4444;">Inactivo</span>
                            </div>
                        </div>
                        <input type="hidden" id="input-inspector" onchange="updateSummary()">

                        <div style="display: grid; grid-template-columns: 1.5fr 1fr; gap: 15px;">
                            <div class="form-group">
                                <label class="form-label">Fecha</label>
                                <input type="date" class="form-control" id="input-fecha" onchange="updateSummary()">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Hora</label>
                                <input type="time" class="form-control" id="input-hora" value="09:00" onchange="updateSummary()">
                            </div>
                        </div>
                    </div>

                    <div class="wizard-step-content" id="step-3">
                         <div class="form-group">
                            <label class="form-label">Notas Adicionales</label>
                            <textarea class="form-control" rows="4" placeholder="Instrucciones especiales para el inspector..."></textarea>
                        </div>
                        <p style="color:#cbd5e1;">Por favor revisa el resumen a la derecha antes de finalizar.</p>
                    </div>

                </div> <div class="wizard-sidebar-col">
                    <h3 class="summary-title">Resumen</h3>
                    
                    <div class="summary-item">
                        <span class="summary-label">Inmueble Seleccionado</span>
                        <span class="summary-value" id="res-inmueble" style="color: #94a3b8;">-</span>
                    </div>

                    <div class="summary-item">
                        <span class="summary-label">Motivo</span>
                        <span class="summary-value" id="res-motivo">Inspección Anual</span>
                    </div>

                     <div class="summary-item" style="border-top: 1px solid #334155; padding-top: 15px;">
                        <span class="summary-label">Inspector Asignado</span>
                        <span class="summary-value" id="res-inspector" style="color: #94a3b8;">Sin asignar</span>
                    </div>

                     <div class="summary-item">
                        <span class="summary-label">Fecha y Hora</span>
                        <span class="summary-value" id="res-fecha" style="color: #94a3b8;">-</span>
                    </div>
                </div> </div> <hr style="border: 0; border-top: 1px solid #334155; margin-top: 30px; margin-bottom: 25px;">
            <div class="form-actions" style="justify-content: space-between;">
                <button type="button" class="btn-cancel" onclick="closeWizard()">Cancelar</button>
                
                <div style="display: flex; gap: 10px;">
                    <button type="button" class="btn-cancel" id="btn-back" onclick="changeStep(-1)" style="display: none;">Atrás</button>
                    <button type="button" class="btn-save" id="btn-next" onclick="changeStep(1)">Siguiente</button>
                    <button type="button" class="btn-save" id="btn-finish" onclick="alert('Solicitud Creada!')" style="display: none; background-color: #10b981;">Finalizar y Programar</button>
                </div>
            </div>
        </form>
    </div>
</div>

                <h4 style="color: #cbd5e1; margin-bottom: 10px;">Resumen de la Solicitud</h4>
                <div class="summary-box">
                    <div class="summary-row">
                        <span class="summary-label">Inmueble:</span>
                        <span class="summary-value" id="res-inmueble">-</span>
                    </div>
                    <div class="summary-row">
                        <span class="summary-label">Motivo:</span>
                        <span class="summary-value" id="res-motivo">-</span>
                    </div>
                    <div class="summary-row" style="border:none; margin:0;">
                        <span class="summary-label">Inspector:</span>
                        <span class="summary-value" id="res-inspector">-</span>
                    </div>
                </div>
            </div>

            <hr style="border: 0; border-top: 1px solid #334155; margin-top: 20px; margin-bottom: 20px;">
            <div class="form-actions" style="justify-content: space-between;">
                <button type="button" class="btn-cancel" onclick="closeWizard()">Cancelar</button>
                
                <div style="display: flex; gap: 10px;">
                    <button type="button" class="btn-cancel" id="btn-back" onclick="changeStep(-1)" style="display: none;">Atrás</button>
                    <button type="button" class="btn-save" id="btn-next" onclick="changeStep(1)">Siguiente</button>
                    <button type="button" class="btn-save" id="btn-finish" onclick="alert('Solicitud Creada!')" style="display: none; background-color: #10b981;">Finalizar</button>
                </div>
            </div>
        </form>
    </div>
</div>



<script>
    let currentStep = 1;
    const totalSteps = 3;

    function openWizard() {
        document.getElementById('modal-wizard').style.display = 'flex';
        resetWizard();
    }

    function closeWizard() {
        document.getElementById('modal-wizard').style.display = 'none';
    }

    function resetWizard() {
        currentStep = 1;
        // Limpiar selecciones
        document.getElementById('form-wizard').reset();
        document.querySelectorAll('.avatar-option').forEach(el => el.classList.remove('selected'));
        document.getElementById('input-inspector').value = "";
        updateWizardUI();
        updateSummary(); // Resetea el resumen
    }

    // --- LÓGICA DE SELECCIÓN DE AVATAR ---
    function selectInspector(element, name) {
        // Quitar selección previa
        document.querySelectorAll('.avatar-option').forEach(el => el.classList.remove('selected'));
        // Activar el clicado
        element.classList.add('selected');
        // Guardar valor en input oculto y actualizar resumen
        document.getElementById('input-inspector').value = name;
        updateSummary();
    }

    function changeStep(direction) {
        // Validación simple (ejemplo)
        if (direction === 1 && currentStep === 1 && document.getElementById('input-inmueble').value === "") {
            alert("Por favor selecciona un inmueble."); return;
        }
        currentStep += direction;
        updateWizardUI();
    }

    function updateWizardUI() {
        // 1. Actualizar Barra de Progreso
        const progressFill = document.getElementById('progress-fill');
        // Calcula el porcentaje: (paso actual - 1) / (total pasos - 1) * 100
        let progressPercentage = ((currentStep - 1) / (totalSteps - 1)) * 100;
        progressFill.style.width = progressPercentage + "%";

        for (let i = 1; i <= totalSteps; i++) {
            // Mostrar contenido del paso
            document.getElementById('step-' + i).classList.toggle('active', i === currentStep);
            
            // Actualizar estilo de los círculos
            const stepEl = document.getElementById('p-step-' + i);
            stepEl.classList.remove('step-active-m', 'step-completed-m');
            const circle = stepEl.querySelector('.step-circle-m');

            if (i < currentStep) {
                stepEl.classList.add('step-completed-m');
                circle.innerHTML = '<i class="fa-solid fa-check"></i>'; // Palomita
            } else if (i === currentStep) {
                stepEl.classList.add('step-active-m');
                circle.innerHTML = i;
            } else {
                circle.innerHTML = i;
            }
        }

        // 2. Controlar Botones
        document.getElementById('btn-back').style.display = (currentStep === 1) ? 'none' : 'block';
        document.getElementById('btn-next').style.display = (currentStep === totalSteps) ? 'none' : 'block';
        document.getElementById('btn-finish').style.display = (currentStep === totalSteps) ? 'block' : 'none';
    }

    // --- ACTUALIZAR RESUMEN EN TIEMPO REAL ---
    function updateSummary() {
        const inmueble = document.getElementById('input-inmueble').value;
        const inspector = document.getElementById('input-inspector').value;
        const fecha = document.getElementById('input-fecha').value;
        const hora = document.getElementById('input-hora').value;

        // Actualizar textos y colores si hay valor
        const resInmueble = document.getElementById('res-inmueble');
        resInmueble.innerText = inmueble || 'No seleccionado';
        resInmueble.style.color = inmueble ? 'white' : '#94a3b8';

        document.getElementById('res-motivo').innerText = document.getElementById('input-motivo').value;

        const resInspector = document.getElementById('res-inspector');
        resInspector.innerText = inspector || 'Sin asignar';
        resInspector.style.color = inspector ? 'white' : '#94a3b8';

        const resFecha = document.getElementById('res-fecha');
        resFecha.innerText = (fecha && hora) ? (fecha + ' ' + hora) : '-';
        resFecha.style.color = (fecha && hora) ? 'white' : '#94a3b8';
    }

    window.onclick = function(event) {
        if (event.target == document.getElementById('modal-wizard')) closeWizard();
    }
</script>


</body>
</html>