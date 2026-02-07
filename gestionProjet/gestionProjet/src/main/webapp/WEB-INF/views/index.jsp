<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Front Office - Accueil</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .container {
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            text-align: center;
            max-width: 600px;
        }
        h1 {
            color: #333;
            margin-bottom: 20px;
        }
        .message {
            color: #667eea;
            font-size: 1.2em;
            margin-bottom: 15px;
        }
        .date {
            color: #888;
            font-size: 0.9em;
            margin-bottom: 30px;
        }
        .btn {
            display: inline-block;
            padding: 12px 30px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-decoration: none;
            border-radius: 25px;
            font-weight: bold;
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        .status {
            margin-top: 30px;
            padding: 15px;
            background: #d4edda;
            border-radius: 8px;
            color: #155724;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🏨 Front Office</h1>
        <p class="message">${message}</p>
        <p class="date">Date: ${date}</p>
        
        <div style="display: flex; gap: 15px; justify-content: center; flex-wrap: wrap;">
            <a href="${pageContext.request.contextPath}/reservations" class="btn">📋 Liste des Réservations</a>
            <a href="${pageContext.request.contextPath}/test" class="btn" style="background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);">🧪 Page de Test</a>
        </div>
        
        <div class="status">
            ✅ L'application Front Office est opérationnelle!<br>
            <small style="color: #666;">API Back-Office: ${apiUrl}</small>
        </div>
    </div>
</body>
</html>
