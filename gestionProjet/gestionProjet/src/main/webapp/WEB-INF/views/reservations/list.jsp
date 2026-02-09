<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Front Office - Liste des Réservations</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f6fa;
            min-height: 100vh;
        }
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px 40px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .header h1 {
            font-size: 1.8em;
        }
        .header p {
            opacity: 0.9;
            margin-top: 5px;
        }
        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }
        .search-box {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.08);
            margin-bottom: 30px;
        }
        .search-box h3 {
            color: #333;
            margin-bottom: 15px;
        }
        .search-form {
            display: flex;
            gap: 15px;
            align-items: center;
            flex-wrap: wrap;
        }
        .search-form label {
            font-weight: 500;
            color: #555;
        }
        .search-form input[type="datetime-local"] {
            padding: 10px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 1em;
            transition: border-color 0.3s;
        }
        .search-form input[type="datetime-local"]:focus {
            outline: none;
            border-color: #667eea;
        }
        .btn {
            padding: 10px 25px;
            border: none;
            border-radius: 8px;
            font-size: 1em;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        .btn-secondary:hover {
            background: #5a6268;
        }
        .stats {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }
        .stat-badge {
            background: #667eea;
            color: white;
            padding: 8px 15px;
            border-radius: 20px;
            font-size: 0.9em;
        }
        .alert {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .alert-info {
            background: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }
        .table-container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.08);
            overflow: hidden;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th {
            background: #667eea;
            color: white;
            padding: 15px;
            text-align: left;
            font-weight: 500;
        }
        td {
            padding: 15px;
            border-bottom: 1px solid #eee;
            color: #333;
        }
        tr:hover {
            background: #f8f9ff;
        }
        tr:last-child td {
            border-bottom: none;
        }
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #888;
        }
        .empty-state .icon {
            font-size: 4em;
            margin-bottom: 15px;
        }
        .nav-links {
            margin-top: 30px;
        }
        .nav-links a {
            color: #667eea;
            text-decoration: none;
            margin-right: 20px;
        }
        .nav-links a:hover {
            text-decoration: underline;
        }
        .client-id {
            font-family: monospace;
            background: #e9ecef;
            padding: 3px 8px;
            border-radius: 4px;
        }
        .badge-type {
            background: #17a2b8;
            color: white;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 0.85em;
        }
        .badge-statut {
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 0.85em;
            font-weight: 500;
        }
        .badge-en_attente {
            background: #ffc107;
            color: #333;
        }
        .badge-confirmee {
            background: #28a745;
            color: white;
        }
        .badge-annulee {
            background: #dc3545;
            color: white;
        }
        .badge-terminee {
            background: #6c757d;
            color: white;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>🏨 Front Office - Réservations</h1>
        <p>Liste des réservations d'hôtel</p>
    </div>
    
    <div class="container">
        <!-- Formulaire de recherche par plage de dates -->
        <div class="search-box">
            <h3>🔍 Rechercher par plage de dates</h3>
            <form class="search-form" action="${pageContext.request.contextPath}/reservations" method="get">
                <label for="start">Du :</label>
                <input type="datetime-local" id="start" name="start" value="${startValue}">
                <label for="end">Au :</label>
                <input type="datetime-local" id="end" name="end" value="${endValue}">
                <button type="submit" class="btn btn-primary">Rechercher</button>
                <c:if test="${not empty startValue || not empty endValue}">
                    <a href="${pageContext.request.contextPath}/reservations" class="btn btn-secondary">Réinitialiser</a>
                </c:if>
            </form>
        </div>
        
        <!-- Messages d'erreur -->
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-error">
                ⚠️ ${errorMessage}
            </div>
        </c:if>
        
        <!-- Info recherche -->
        <c:if test="${searchPerformed}">
            <div class="alert alert-info">
                📅 Résultats pour la période :
                <c:if test="${not empty startValue}">
                    du <strong>${startValue}</strong>
                </c:if>
                <c:if test="${not empty endValue}">
                    au <strong>${endValue}</strong>
                </c:if>
            </div>
        </c:if>
        
        <!-- Stats -->
        <div class="stats">
            <span class="stat-badge">📋 ${totalCount} réservation(s) trouvée(s)</span>
        </div>
        
        <!-- Tableau des réservations -->
        <div class="table-container">
            <c:choose>
                <c:when test="${empty reservations}">
                    <div class="empty-state">
                        <div class="icon">📭</div>
                        <h3>Aucune réservation trouvée</h3>
                        <p>
                            <c:choose>
                                <c:when test="${searchPerformed}">
                                    Aucune réservation pour cette date.
                                </c:when>
                                <c:otherwise>
                                    Le back-office n'a retourné aucune réservation ou l'API est indisponible.
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </c:when>
                <c:otherwise>
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Client</th>
                                <th>Places</th>
                                <th>Date & Heure Arrivée</th>
                                <th>Hôtel</th>
                                <th>Créé le</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${reservations}" var="reservation">
                                <tr>
                                    <td><strong>#${reservation.id}</strong></td>
                                    <td><span class="client-id">${reservation.clientId}</span></td>
                                    <td>${reservation.placesRequises} 👥</td>
                                    <td>
                                        <fmt:parseDate value="${reservation.dateheureArrive}" pattern="yyyy-MM-dd HH:mm:ss.S" var="parsedDate" />
                                        <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy 'à' HH:mm" />
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty reservation.hotel}">
                                                ${reservation.hotel.nom}
                                            </c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <fmt:parseDate value="${reservation.creeLe}" pattern="yyyy-MM-dd HH:mm:ss.S" var="parsedCreeLe" />
                                        <fmt:formatDate value="${parsedCreeLe}" pattern="dd/MM/yyyy HH:mm" />
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
        
        <!-- Navigation -->
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/">← Retour à l'accueil</a>
        </div>
    </div>
</body>
</html>
