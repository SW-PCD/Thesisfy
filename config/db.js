const mysql = require('mysql2');

const connection = mysql.createConnection({
    host: 'localhost',
    user: 'root', // MySQL 사용자명
    password: '0000', // MySQL 비밀번호
    database: 'thesisfy_db' // 사용 중인 데이터베이스 이름
});

connection.connect((err) => {
    if (err) {
        console.error('DB 연결 실패:', err);
    } else {
        console.log('DB 연결 성공');
    }
});

module.exports = connection;
