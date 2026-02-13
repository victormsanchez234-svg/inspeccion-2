<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>.: Proteccion Civil - Inspeccion Acceso :.</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="css/app.css" rel="stylesheet" type="text/css" />
<link href="imagenes/faviconhor.png" rel="shortcut icon" type="image/png">
</head>

<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ page import="org.apache.commons.fileupload.*,librerias.base.*, librerias.comun.*, java.sql.*, java.util.*, java.io.File"%>

<%
String usuario = request.getParameter("usuario");
String contrasena = request.getParameter("contrasena");
String mensaje = "";
String sql = "";

if (usuario != null && contrasena != null) {

  sql =
  "select u.cve_usuarios, t.cve_trabajadores, r.nombre as rol " +
  "from usuarios u " +
  "inner join trabajadores t on u.cve_usuarios = t.cve_usuarios " +
  "inner join roles r on t.cve_roles = r.cve_roles " +
  "where u.nombre = " + Utilerias.Comillas(usuario) +
  " and u.contrasena = " + Utilerias.Comillas(contrasena) +
  " and t.activo = 1";

  Resultados rs = UtilDB.ejecutaConsulta(sql);

  if (rs != null && rs.recordCount() > 0) {
    rs.next();

    session.setAttribute("cve_usuarios", new Integer(rs.getInt("cve_usuarios")));
    session.setAttribute("cve_trabajadores", new Integer(rs.getInt("cve_trabajadores")));
    session.setAttribute("rol", rs.getString("rol"));
    session.setAttribute("usuario", usuario);

    response.sendRedirect("dashboard.jsp");
    return;
  } else {
    mensaje = "Usuario o contraseña incorrectos.";
  }
}
%>

<body>

<div class="login-card">

  <header class="header">
    <img src="assets/img/logo.png" class="logo"  style="width: 150px; height: auto; display: block; margin: 0 auto;">
    <h1>Protección Civil</h1>
    <p>Inspeccion y Supervision</p>
  </header>

  <form action="login.jsp" method="post" class="login-form" autocomplete="off">

    <h2>Iniciar Sesion</h2>

    <div class="form-group">
      <label>Usuario</label>
      <input type="text" name="usuario" placeholder="Usuario" class="input-field" required>
    </div>

    <div class="form-group">
      <label>Contraseña</label>
      <input type="password" name="contrasena" placeholder="Contraseña" class="input-field" required>
    </div>

    <button type="submit" class="login-button">
      INGRESAR
    </button>

    <% if (!mensaje.equals("")) { %>
    <div class="message-box error show">
      <%= mensaje %>
    </div>
    <% } %>

  </form>
</div>
</body>
</html>
