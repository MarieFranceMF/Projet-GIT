<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Front Office - Test</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
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
        .success {
            color: #11998e;
            font-size: 1.3em;
            margin-bottom: 20px;
        }
        .info-box {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin: 20px 0;
            text-align: left;
        }
        .info-box h3 {
            color: #333;
            margin-bottom: 10px;
        }
        .info-box ul {
            list-style: none;
            padding: 0;
        }
        .info-box li {
            padding: 8px 0;
            border-bottom: 1px solid #eee;
            color: #555;
        }
        .info-box li:last-child {
            border-bottom: none;
        }
        .info-box li span {
            color: #11998e;
            font-weight: bold;
        }
        .btn {
            display: inline-block;
            padding: 12px 30px;
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            color: white;
            text-decoration: none;
            border-radius: 25px;
            font-weight: bold;
            transition: transform 0.3s, box-shadow 0.3s;
            margin-top: 20px;
        }
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(17, 153, 142, 0.4);
        }
        .check {
            font-size: 4em;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="check">✅</div>
        <h1>${title}</h1>
        <p class="success">${description}</p>
        
        <div class="info-box">
            <h3>📋 Configuration actuelle:</h3>
            <ul>
                <li>Framework: <span>Spring Boot 3.2.2</span></li>
                <li>View Engine: <span>JSP + JSTL</span></li>
                <li>Base de données: <span>PostgreSQL</span></li>
                <li>Port: <span>8080</span></li>
                <li>Type: <span>Front Office (Public)</span></li>
            </ul>
        </div>
        
        <a href="/" class="btn">← Retour à l'accueil</a>
    </div>
</body>
</html>
