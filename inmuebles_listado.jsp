<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>.: Inmuebles - Protección Civil :.</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="css/estilos.css" rel="stylesheet" type="text/css" />
<link href="imagenes/faviconhor.png" rel="shortcut icon" type="image/png">

<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

<style>
    /* 1. BARRA DE HERRAMIENTAS */
    .toolbar {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
        gap: 15px;
    }
    .search-wrapper {
        flex-grow: 1;
        position: relative;
        max-width: 500px;
    }
    .search-input {
        width: 100%;
        padding: 12px 20px;
        padding-left: 40px;
        background-color: #1e293b;
        border: 1px solid #334155;
        border-radius: 8px;
        color: white;
        font-size: 0.95rem;
    }
    .search-input:focus { outline: none; border-color: #ffab00; }

    /* 2. PESTAÑAS (TABS) */
    .view-tabs {
        display: flex;
        gap: 10px;
        margin-bottom: 20px;
        border-bottom: 1px solid #334155;
        padding-bottom: 10px;
    }
    .tab-btn {
        background: transparent;
        border: none;
        color: #94a3b8;
        padding: 10px 20px;
        cursor: pointer;
        font-weight: 600;
        font-size: 1rem;
        position: relative;
    }
    .tab-btn.active { color: #ffab00; }
    .tab-btn.active::after {
        content: ''; position: absolute; bottom: -11px; left: 0;
        width: 100%; height: 3px; background-color: #ffab00;
    }

    /* 3. BADGES DE RIESGO (Etiquetas de colores) */
    .badge-risk {
        padding: 5px 12px;
        border-radius: 20px;
        font-size: 0.75rem;
        font-weight: bold;
        text-transform: uppercase;
        display: inline-block;
        min-width: 80px;
        text-align: center;
    }
    .bg-alto { background-color: rgba(220, 38, 38, 0.2); color: #ef4444; border: 1px solid #ef4444; }
    .bg-medio { background-color: rgba(245, 158, 11, 0.2); color: #f59e0b; border: 1px solid #f59e0b; }
    .bg-bajo { background-color: rgba(16, 185, 129, 0.2); color: #10b981; border: 1px solid #10b981; }

    /* 4. MODAL FLOTANTE (Oculto por defecto) */
    .modal-overlay {
        display: none; /* ¡ESTO LO OCULTA INICIALMENTE! */
        position: fixed;
        top: 0; left: 0;
        width: 100%; height: 100%;
        background-color: rgba(0, 0, 0, 0.8);
        z-index: 9999;
        justify-content: center;
        align-items: center;
        backdrop-filter: blur(5px);
    }
    .modal-content {
        background-color: #0f172a;
        width: 90%; max-width: 600px;
        border-radius: 16px; padding: 30px;
        border: 1px solid #334155;
        box-shadow: 0 20px 25px rgba(0,0,0,0.5);
    }
    .form-group { margin-bottom: 20px; }
    .form-label { display: block; color: #94a3b8; margin-bottom: 8px; font-size: 0.9rem; }
    .form-control {
        width: 100%; padding: 10px;
        background-color: #1e293b;
        border: 1px solid #334155;
        border-radius: 6px; color: white;
    }
    .form-actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 30px; }
    .btn-cancel { background: #334155; color: white; border: none; padding: 10px 20px; border-radius: 6px; cursor: pointer; }
    .btn-save { background: #ffab00; color: white; border: none; padding: 10px 20px; border-radius: 6px; cursor: pointer; font-weight: bold; }
    
    /* 5. MAPA */
    #map-full { width: 100%; height: 500px; border-radius: 12px; }
</style>
</head>

<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ page import="librerias.base.*, librerias.comun.*, java.util.*"%>

<%
if (session.getAttribute("cve_usuarios") == null) {
  response.sendRedirect("login.jsp");
  return;
}
%>

<body>

<div class="dashboard-container">

    <header class="dashboard-header">
        <h1>Gestión de Inmuebles</h1>
        <div class="header-user-info">
             <span>Usuario: <%= session.getAttribute("usuario") %></span>
             <a href="dashboard.jsp" class="btn-salir" style="background:#334155; margin-left:10px;">VOLVER</a>
        </div>
    </header>

    <div class="view-tabs">
        <button class="tab-btn active" onclick="switchView('list')">Listado General</button>
        <button class="tab-btn" onclick="switchView('map')">Mapa de Riesgos</button>
    </div>

    <div id="view-list">
        
        <div class="toolbar">
            <div class="search-wrapper">
                <i class="fa-solid fa-search" style="position: absolute; left: 15px; top: 13px; color: #94a3b8;"></i>
                <input type="text" class="search-input" placeholder="Buscar por nombre, giro o dirección...">
            </div>
            <button onclick="openModal()" class="action-button" style="background-color: #ffab00; color: white; border:none; cursor: pointer;">
                + Nuevo Inmueble
            </button>
        </div>

        <div class="table-container">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nombre Comercial</th>
                        <th>Giro / Actividad</th>
                        <th>Dirección</th>
                        <th>Riesgo</th>
                        <th style="text-align: center;">Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>101</td>
                        <td><strong>Plaza Las Américas</strong></td>
                        <td>Centro Comercial</td>
                        <td>Av. Universidad #502</td>
                        <td><span class="badge-risk bg-alto">Alto</span></td>
                        <td style="text-align: center;">
                            <a href="#" style="color:#3b82f6; margin-right:10px;"><i class="fa-solid fa-pen"></i></a>
                            <a href="#" style="color:#ef4444;"><i class="fa-solid fa-trash"></i></a>
                        </td>
                    </tr>
                    <tr>
                        <td>102</td>
                        <td><strong>Escuela Benito Juárez</strong></td>
                        <td>Educación</td>
                        <td>Calle 5 de Mayo #20</td>
                        <td><span class="badge-risk bg-medio">Medio</span></td>
                       <td style="text-align: center;">
    <a href="javascript:void(0)" onclick="accionTabla('Editar', 101)" style="color:#3b82f6; margin-right:10px; font-size: 1.1rem; cursor: pointer;">
        <i class="fa-solid fa-pen"></i>
    </a>
    
    <a href="javascript:void(0)" onclick="accionTabla('Eliminar', 101)" style="color:#ef4444; font-size: 1.1rem; cursor: pointer;">
        <i class="fa-solid fa-trash"></i>
    </a>
</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

    <div id="view-map" style="display: none;">
        <div class="panel-chart">
            <div id="map-full"></div>
        </div>
    </div>

</div>

<div id="modal-inmueble" class="modal-overlay">
    <div class="modal-content">
        <h2 style="color: white; margin-top: 0;">Registrar Nuevo Inmueble</h2>
        <hr style="border: 0; border-top: 1px solid #334155; margin-bottom: 20px;">
        
        <form action="#" method="post">
            <div class="form-group">
                <label class="form-label">Nombre Comercial</label>
                <input type="text" class="form-control" name="nombre" placeholder="Ej. Plaza Crystal">
            </div>

            <div class="form-group">
                <label class="form-label">Dirección Completa</label>
                <input type="text" class="form-control" name="direccion" placeholder="Calle, Número, Colonia...">
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                <div class="form-group">
                    <label class="form-label">Giro</label>
                    <select class="form-control" name="giro">
                        <option>Comercial</option>
                        <option>Industrial</option>
                        <option>Educativo</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">Nivel de Riesgo</label>
                    <select class="form-control" name="riesgo">
                        <option value="bajo">Bajo (Verde)</option>
                        <option value="medio">Medio (Naranja)</option>
                        <option value="alto">Alto (Rojo)</option>
                    </select>
                </div>
            </div>

            <div class="form-actions">
                <button type="button" class="btn-cancel" onclick="closeModal()">Cancelar</button>
                <button type="submit" class="btn-save">Guardar</button>
            </div>
        </form>
    </div>
</div>

<script>
    // Variables globales
    var map = null;

    // --- 1. FUNCIÓN PARA CAMBIAR VISTAS (Tabs) ---
    function switchView(viewName) {
        // Ocultar ambas vistas
        var listDiv = document.getElementById('view-list');
        var mapDiv = document.getElementById('view-map');
        
        if (!listDiv || !mapDiv) return; // Protección contra errores

        listDiv.style.display = 'none';
        mapDiv.style.display = 'none';
        
        // Quitar clase 'active' a todos los botones
        var tabs = document.querySelectorAll('.tab-btn');
        tabs.forEach(function(btn) { btn.classList.remove('active'); });

        if (viewName === 'list') {
            // Mostrar Lista
            listDiv.style.display = 'block';
            if(tabs[0]) tabs[0].classList.add('active');
        } else {
            // Mostrar Mapa
            mapDiv.style.display = 'block';
            if(tabs[1]) tabs[1].classList.add('active');
            
            // Truco para que el mapa se pinte bien al hacerse visible
            setTimeout(function() {
                if (!map) {
                    initMapFull();
                } else {
                    map.invalidateSize();
                }
            }, 200);
        }
    }

    // --- 2. INICIALIZAR MAPA ---
    function initMapFull() {
        // Verificar si la librería Leaflet cargó correctamente
        if (typeof L === 'undefined') {
            console.error("Leaflet no ha cargado todavía");
            return;
        }

        map = L.map('map-full').setView([17.9869, -92.9303], 13);
        
        L.tileLayer('https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png', { 
            attribution: '' 
        }).addTo(map);

        // Marcadores de ejemplo
        var marker1 = L.circleMarker([17.99, -92.94], { color: '#ef4444', fillColor: '#ef4444', fillOpacity: 0.8, radius: 8 }).addTo(map);
        marker1.bindPopup("<b>Plaza Las Américas</b><br>Riesgo: Alto");

        var marker2 = L.circleMarker([17.985, -92.93], { color: '#f59e0b', fillColor: '#f59e0b', fillOpacity: 0.8, radius: 8 }).addTo(map);
        marker2.bindPopup("<b>Escuela Benito Juárez</b><br>Riesgo: Medio");
    }

    // --- 3. FUNCIONES DEL MODAL (Nuevo Inmueble) ---
    function openModal() {
        var modal = document.getElementById('modal-inmueble');
        if (modal) {
            modal.style.display = 'flex'; // Usamos flex para centrarlo
        } else {
            alert("Error: No se encuentra el modal");
        }
    }

    function closeModal() {
        var modal = document.getElementById('modal-inmueble');
        if (modal) modal.style.display = 'none';
    }

    // Cerrar si hacen clic fuera del cuadro del modal
    window.onclick = function(event) {
        var modal = document.getElementById('modal-inmueble');
        if (event.target == modal) {
            closeModal();
        }
    }

    // --- 4. ACCIONES DE TABLA (Editar/Eliminar) ---
    // Esta función se activará al hacer clic en los lápices o basureros
    function accionTabla(accion, id) {
        alert("Botón " + accion + " presionado para el ID: " + id + "\n(Aquí abrirías la lógica de edición)");
    }
</script>