const express = require('express');
const bcrypt = require('bcrypt');
const db = require('./config/db');  //db 연결 파일
const openai=require('./config/openaiClient');  //openai client 가져오기
const app = express();

app.use(express.json());    //json 요청 파싱

//테스트용 나중에 삭제할 항목
app.get('/', (req, res) => {
    res.send('Hello, thesisfy server!');
});


// 사용자 정보 가져오기
app.get('/users', async (req, res) => {
    try {
        const [rows] = await db.query('SELECT * FROM users');
        res.json(rows);
    } catch (err) {
        res.status(500).json({ error: 'DB 오류' });
    }
});

// 회원가입 API
app.post('/register', async (req, res) => {
    const { email, password, nickname, job } = req.body;

    try {
        // 비밀번호 암호화
        const hashedPassword = await bcrypt.hash(password, 10);

        // 사용자 정보 DB에 삽입
        const query = 'INSERT INTO users (email, password, nickname, job) VALUES (?, ?, ?, ?)';
        db.query(query, [email, hashedPassword, nickname, job], (err, result) => {
            if (err) {
                console.error('회원가입 오류:', err);
                return res.status(500).json({ error: '회원가입 중 오류가 발생했습니다.' });
            }
            res.status(201).json({ message: '회원가입 성공!' });
        });
    } catch (error) {
        console.error('회원가입 중 오류:', error);
        res.status(500).json({ error: '서버 오류' });
    }
});

// 로그인 API
app.post('/login', (req, res) => {
    const { email, password } = req.body;

    const query = 'SELECT * FROM users WHERE email = ?';
    db.query(query, [email], async (err, results) => {
        if (err) {
            console.error('로그인 오류:', err);
            return res.status(500).json({ error: '서버 오류' });
        }

        if (results.length === 0) {
            return res.status(401).json({ error: '이메일 또는 비밀번호가 잘못되었습니다.' });
        }

        const user = results[0];
        // 비밀번호 비교
        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) {
            return res.status(401).json({ error: '이메일 또는 비밀번호가 잘못되었습니다.' });
        }

        res.status(200).json({ message: '로그인 성공!', user: { id: user.id, email: user.email, nickname: user.nickname, job: user.job } });
    });
});

// 로그아웃 API (클라이언트에서 토큰/세션 삭제)
app.post('/logout', (req, res) => {
    // 여기서는 로그아웃 요청 확인만 처리
    res.status(200).json({ message: '로그아웃 성공!' });
});

// 회원탈퇴 API
app.delete('/users/delete', async (req, res) => {
    const { email, password } = req.body;

    try {
        // 사용자 조회
        const query = 'SELECT * FROM users WHERE email = ?';
        db.query(query, [email], async (err, results) => {
            if (err) {
                console.error('회원탈퇴 오류:', err);
                return res.status(500).json({ error: '서버 오류' });
            }

            if (results.length === 0) {
                return res.status(404).json({ error: '사용자를 찾을 수 없습니다.' });
            }

            const user = results[0];

            // 비밀번호 검증
            const isMatch = await bcrypt.compare(password, user.password);
            if (!isMatch) {
                return res.status(401).json({ error: '비밀번호가 잘못되었습니다.' });
            }

            // 사용자 삭제
            const deleteQuery = 'DELETE FROM users WHERE email = ?';
            db.query(deleteQuery, [email], (err, result) => {
                if (err) {
                    console.error('삭제 오류:', err);
                    return res.status(500).json({ error: '회원탈퇴 실패' });
                }
                res.status(200).json({ message: '회원탈퇴 성공!' });
            });
        });
    } catch (error) {
        console.error('회원탈퇴 처리 중 오류:', error);
        res.status(500).json({ error: '서버 오류' });
    }
});

// 개인정보 수정 API ---비밀번호 수정 따로 만들기
app.put('/users/update', async (req, res) => {
    const { email, password, job, nickname } = req.body;

    try {
        // 사용자 확인
        const query = 'SELECT * FROM users WHERE email = ?';
        db.query(query, [email], async (err, results) => {
            if (err) {
                console.error('개인정보 수정 오류:', err);
                return res.status(500).json({ error: '서버 오류' });
            }

            if (results.length === 0) {
                return res.status(404).json({ error: '사용자를 찾을 수 없습니다.' });
            }

            // 수정할 데이터 준비
            const updatedFields = {};
            if (password) {
                const hashedPassword = await bcrypt.hash(password, 10);
                updatedFields.password = hashedPassword;
            }
            if (job) {
                updatedFields.job = job;
            }
            if (nickname) {
                updatedFields.nickname = nickname;
            }

            // SQL 동적 생성
            const setClause = Object.keys(updatedFields)
                .map((field) => `${field} = ?`)
                .join(', ');
            const values = Object.values(updatedFields);
            values.push(email); // WHERE 조건에 사용할 email 추가

            const updateQuery = `UPDATE users SET ${setClause} WHERE email = ?`;

            // DB 업데이트 실행
            db.query(updateQuery, values, (err, result) => {
                if (err) {
                    console.error('수정 중 오류:', err);
                    return res.status(500).json({ error: '정보 수정 실패' });
                }
                res.status(200).json({ message: '정보 수정 성공!' });
            });
        });
    } catch (error) {
        console.error('개인정보 수정 중 오류:', error);
        res.status(500).json({ error: '서버 오류' });
    }
});

// 대화 내용 저장 함수 (chatopenai 테이블에 저장)
const saveConversation = (userId, message) => {
    return new Promise((resolve, reject) => {
        // SQL 쿼리 작성: 사용자 ID와 메시지를 chatopenai 테이블에 삽입
        const query = 'INSERT INTO chatopenai (user_id, message) VALUES (?, ?)';

        // MySQL 쿼리 실행
        db.query(query, [userId, message], (err, results) => {
            if (err) {
                reject(err);  // 에러가 발생하면 Promise를 reject
            } else {
                resolve(results);  // 성공적으로 삽입되면 Promise를 resolve
            }
        });
    });
};

// OpenAI API
app.post('/chat', async (req, res) => {
    const { userId, prompt } = req.body;

    // 사용자 ID와 프롬프트가 전달되지 않으면 오류 응답
    if (!userId || !prompt) {
        return res.status(400).json({ error: '사용자 ID와 프롬프트가 필요합니다.' });
    }

    try {
        // 1. 사용자 ID가 'users' 테이블에 존재하는지 확인
        db.query('SELECT * FROM users WHERE id = ?', [userId], async (err, results) => {
            if (err) {
                console.error('DB 오류:', err);
                return res.status(500).json({ error: 'DB 오류' });
            }

            // 2. 사용자 ID가 없으면 오류 응답
            if (results.length === 0) {
                return res.status(400).json({ error: '존재하지 않는 사용자입니다.' });
            }

            // 3. OpenAI API 호출 (사용자의 프롬프트에 대한 응답 받기)
            const response = await openai.chat.completions.create({
                model: 'gpt-4',
                messages: [{ role: 'user', content: prompt }],
            });

            const reply = response.choices[0].message.content;  // OpenAI 응답

            // 4. 대화 내용 DB에 저장 (사용자 메시지와 응답 모두 저장)
            await saveConversation(userId, prompt);  // 사용자가 입력한 메시지 저장
            await saveConversation(1, reply);         // 예시로 OpenAI의 응답을 저장 (user_id=1로 설정)

            // 5. 클라이언트에 응답 반환
            res.status(200).json({ reply });  // OpenAI 응답을 클라이언트로 전달
        });
    } catch (error) {
        console.error('OpenAI API 호출 오류:', error);
        res.status(500).json({ error: 'OpenAI API 호출 실패' });
    }
});

const PORT = 3000;
app.listen(PORT, () => console.log(`서버 실행 중: http://localhost:${PORT}`));
