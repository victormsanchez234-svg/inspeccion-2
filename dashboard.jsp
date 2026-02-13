<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>.: Protección Civil - Dashboard :.</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="css/estilos.css" rel="stylesheet" type="text/css" />
<link href="imagenes/faviconhor.png" rel="shortcut icon" type="image/png">
</head>

<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ page import="librerias.base.*, librerias.comun.*, java.util.*"%>

<%
if (session.getAttribute("cve_usuarios") == null) {
  response.sendRedirect("login.jsp");
  return;
}

String sqlTotales =
"select " +
"cast(count(*) as decimal(10,0)) as total, " +
"cast(sum(case when status='aprobada' then 1 else 0 end) as decimal(10,0)) as aprobadas, " +
"cast(sum(case when status='reprobada' then 1 else 0 end) as decimal(10,0)) as reprobadas, " +
"cast(sum(case when status='sin_acceso' then 1 else 0 end) as decimal(10,0)) as sin_acceso " +
"from actas_inspeccion";

Resultados rsTotales = UtilDB.ejecutaConsulta(sqlTotales);

int total = 0;
int aprobadas = 0;
int reprobadas = 0;
int sinAcceso = 0;

if (rsTotales != null && rsTotales.recordCount() > 0) {
  rsTotales.next();
  total = rsTotales.getInt("total");
  aprobadas = rsTotales.getInt("aprobadas");
  reprobadas = rsTotales.getInt("reprobadas");
  sinAcceso = rsTotales.getInt("sin_acceso");
}

String sqlUltimas =
"select " +
"a.num_acta, " +
"date_format(a.fecha,'%d/%m/%Y %H:%i') as fecha, " +
"a.status, " +
"i.nombre_comercial " +
"from actas_inspeccion a " +
"inner join inmuebles i on a.cve_inmuebles = i.cve_inmuebles " +
"order by a.fecha desc " +
"limit 10";

Resultados rsUltimas = UtilDB.ejecutaConsulta(sqlUltimas);
%>

<body>

<div class="dashboard-container">

  <header class="dashboard-header">
    <h1>Departamento de Inspeccion y Supervision</h1>

    <div class="header-right"></div>
        <img src="assets/img/logo.png" alt="Logo Institución" class="top-logo">
        
    </div>
</header>

  <div class="kpi-container">
    <div class="kpi-card">
      <h3>Total Inspecciones</h3>
      <span><%= total %></span>
    </div>
    <div class="kpi-card">
      <h3>Aprobadas</h3>
      <span><%= aprobadas %></span>
    </div>
    <div class="kpi-card">
      <h3>Reprobadas</h3>
      <span><%= reprobadas %></span>
    </div>
    <div class="kpi-card">
      <h3>Sin Acceso</h3>
      <span><%= sinAcceso %></span>
    </div>
  </div>

  <div class="actions-container">
    <a href="actas_nueva.jsp" class="action-button">Nueva Inspección</a>
    <a href="inmuebles_listado.jsp" class="action-button">Inmuebles</a>
    <a href="actas_listado.jsp" class="action-button">Actas</a>

    <% if ("ADMIN".equals(session.getAttribute("rol"))) { %>
      <a href="inspectores_listado.jsp" class="action-button">Inspectores</a>
    <% } %>
  </div>


    
 <div class="chart-section" style="margin-top: 20px; margin-bottom: 20px;">
    <div class="panel-chart" style="display: flex; flex-direction: row; align-items: center; justify-content: space-around; height: 220px; width: 100%; padding: 10px;">
        
        <div style="width: 40%; text-align: center; height: 100%;">
            <h3 style="margin: 0 0 10px 0; font-size: 1rem;">Desglose de Estatus</h3>
            <div style="height: 160px; width: 100%; position: relative;">
                <canvas id="doughnutChart"></canvas>
            </div>
        </div>

        
        <div style="width: 40%; border-left: 2px solid #334155; padding-left: 20px; display: flex; flex-direction: column; justify-content: center;">
            <div style="margin-bottom: 15px;">
                <span style="font-size: 2.5rem; font-weight: bold; color: white; line-height: 1;"><%= total %></span>
                <span style="display: block; color: #94a3b8; font-size: 0.85rem; text-transform: uppercase; letter-spacing: 1px;">Total Inspecciones</span>
            </div>
            
            <div style="display: flex; flex-direction: column; gap: 5px; font-size: 0.9rem; color: #cbd5e1;">
                <div style="display: flex; align-items: center;">
                    <span class="dot green" style="width: 10px; height: 10px; border-radius: 50%; background-color: #00e676; margin-right: 8px;"></span> 
                    Aprobadas: <strong style="color: white; margin-left: 5px;"><%= aprobadas %></strong>
                </div>
                <div style="display: flex; align-items: center;">
                    <span class="dot red" style="width: 10px; height: 10px; border-radius: 50%; background-color: #ff1744; margin-right: 8px;"></span> 
                    Reprobadas: <strong style="color: white; margin-left: 5px;"><%= reprobadas %></strong>
                </div>
                <div style="display: flex; align-items: center;">
                    <span class="dot orange" style="width: 10px; height: 10px; border-radius: 50%; background-color: #ffb300; margin-right: 8px;"></span> 
                    Sin Acceso: <strong style="color: white; margin-left: 5px;"><%= sinAcceso %></strong>
                </div>
            </div>
        </div>

    </div>
</div>

  <div class="bottom-section">
    
  <div class="bottom-grid-container">

    <div class="table-section">
        <div class="section-header">
            <h2>Últimas Inspecciones</h2>
        </div>
        <table class="data-table">
            <tr>
                <th>No. Acta</th>
                <th>Inmueble</th>
                <th>Fecha</th>
                <th>Status</th>
            </tr>
            <% if (rsUltimas != null && rsUltimas.recordCount() > 0) {
                  while (rsUltimas.next()) { %>
            <tr>
                <td><%= rsUltimas.getString("num_acta") %></td>
                <td><%= rsUltimas.getString("nombre_comercial") %></td>
                <td><%= rsUltimas.getString("fecha") %></td>
                <td><span class="badge"><%= rsUltimas.getString("status") %></span></td>
            </tr>
            <%   }
                    } else { %>
            <tr>
                <td colspan="4" style="text-align: center; padding: 20px;">No hay inspecciones registradas</td>
            </tr>
            <% } %>
        </table>
    </div>

    <div class="actions-widget">
        <div class="widget-header">
            <h3>Acciones</h3>
            <span>•••</span>
        </div>
        
        <div class="map-wrapper">
        <div id="mapa-gratis"></div>
        </div>

        <div class="activity-list">
            <div class="activity-item">
                <div class="dot orange"></div>
                <div>
                    <strong>Nueva Inspección</strong><br>
                    <small>Paseo con anexo...</small>
                </div>
            </div>
            <div class="activity-item">
                <div class="dot blue"></div>
                <div>
                    <strong>Inspector Asignado</strong><br>
                    <small>Roberto G. en sector norte</small>
                </div>
            </div>
        </div>
    </div>

</div> <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script>
    var map = L.map('mapa-gratis').setView([17.9869, -92.9303], 13);
    L.tileLayer('https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png', {
        attribution: '&copy; OpenStreetMap &copy; CARTO'
    }).addTo(map);
</script>

</div>
        
        <div class="mini-activity">
            <p><strong>• Nueva Inspección:</strong> Paseo con anexo...</p>
        </div>
    </div>

  </div> <script src="https://maps.googleapis.com/maps/api/js?key=TU_API_KEY&callback=initMap" async defer></script>
  
  <div class="widget-flotante">
    <h3>Info</h3>
    <div class="user-info">
    Usuario: <%= session.getAttribute("usuario") %> | 
    Rol: <%= session.getAttribute("rol") %>
    <a href="logout.jsp" class="btn-salir">SALIR</a>
</div>

</div>

  <script>
    function initMap() {
      // Coordenadas iniciales (ejemplo: Centro de CDMX)
      var centro = { lat: 19.4326, lng: -99.1332 }; 

      // Estilo Oscuro (Dark Mode) para el mapa
      var darkStyle = [
        { elementType: "geometry", stylers: [{ color: "#242f3e" }] },
        { elementType: "labels.text.stroke", stylers: [{ color: "#242f3e" }] },
        { elementType: "labels.text.fill", stylers: [{ color: "#746855" }] },
        { featureType: "administrative.locality", elementType: "labels.text.fill", stylers: [{ color: "#d59563" }] },
        { featureType: "road", elementType: "geometry", stylers: [{ color: "#38414e" }] },
        { featureType: "road", elementType: "geometry.stroke", stylers: [{ color: "#212a37" }] },
        { featureType: "road", elementType: "labels.text.fill", stylers: [{ color: "#9ca5b3" }] },
        { featureType: "water", elementType: "geometry", stylers: [{ color: "#17263c" }] }
      ];

      var map = new google.maps.Map(document.getElementById("google-map"), {
        zoom: 12,
        center: centro,
        styles: darkStyle, // Aplica el estilo oscuro
        disableDefaultUI: true // Quita botones feos para que se vea limpio
      });

      // Marcador de ejemplo
      new google.maps.Marker({
        position: centro,
        map: map,
        title: "Oficina Central"
      });
    }
  </script>

</div>

<script>
    // 1. CAPTURAR VARIABLES DE JSP
   var valAprobadas = Number("<%= aprobadas %>");
    var valReprobadas = Number("<%= reprobadas %>");
    var valSinAcceso = Number("<%= sinAcceso %>");

    // 2. CONFIGURACIÓN DE LA GRÁFICA
    var ctx = document.getElementById('doughnutChart').getContext('2d');
    new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: ['Aprobadas', 'Reprobadas', 'Sin Acceso'],
            datasets: [{
                data: [valAprobadas, valReprobadas, valSinAcceso],
                backgroundColor: [
                    '#00e676', // Verde Neón
                    '#ff1744', // Rojo Intenso
                    '#ffb300'  // Naranja
                ],
                borderWidth: 0, // Sin bordes para que se vea limpio
                hoverOffset: 10 // Efecto al pasar el mouse
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            cutout: '75%', // Hace el agujero del centro más grande (estilo anillo)
            plugins: {
                legend: {
                    display: false // Ocultamos la leyenda automática porque ya hicimos una manual más bonita
                },
                tooltip: {
                    backgroundColor: 'rgba(30, 41, 59, 0.9)',
                    bodyColor: '#fff',
                    borderColor: '#334155',
                    borderWidth: 1
                }
            }
        }
    });
</script>

</body>
</html>
