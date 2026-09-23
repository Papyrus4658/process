<?php
$db = "db";
$dbname = "lampdb";
$host = "mysql:host=$db;dbname=$dbname";
$user = "lampuser";
$pass = "lamppassword";

try {
    $pdo = new PDO($host, $user, $pass);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Create a table if it doesn't exist
    $pdo->exec("create table if not exists visitors(
        id int auto_increment primary key,
        visited_at timestamp default current_timestamp
    )");

    // Log this visit
    $pdo->exec(
        "insert into visitors(visited_at) values
        (now())"
    );

    // Count total visits
    $count = $pdo->query("select count(*) from visitors")->fetchColumn();

    echo "<h1>🐳 LAMP Stack is Running!</h1>";
    echo "<p>This page has been visited <strong>$count</strong> time(s).</p>";
    echo "<p>Database connection: <strong style='color:green'>Successful ✅</strong></p>";
    echo "<p>PHP version: " . phpversion() . "</p>";
} catch (PDOException $e) {
    echo "<h1>Database Error</h1>";
    echo "<p>" . $e->getMessage() . "</p>";
}