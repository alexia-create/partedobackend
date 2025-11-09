import express from 'express';
import cors from 'cors';
import pool from './bd.js';

const app = express();
const port = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());


app.post('/login', async (req, res) => {
    const { email, password } = req.body;
    if (!email || !password) {
        return res.status(400).json({ message: 'Email e senha são obrigatórios.' });
    }
    try {
        const [rows] = await pool.query(
            'SELECT * FROM funcionarios WHERE email = ? AND senha = ?',
            [email, password]
        );
        if (rows.length > 0) {
            const funcionario = rows[0];
            delete funcionario.senha;
            res.json({ message: 'Login bem-sucedido!', user: funcionario });
        } else {
            res.status(401).json({ message: 'Email ou senha incorretos.' });
        }
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Erro no servidor.' });
    }
});


app.get('/alunos', async (req, res) => {
    try {
        const [rows] = await pool.query('SELECT * FROM alunos ORDER BY nome_aluno');
        res.json(rows);
    } catch (error) {
        res.status(500).json({ message: 'Erro ao buscar alunos.' });
    }
});


app.post('/alunos', async (req, res) => {
    const { nome, dataNascimento, pai, mae, email, telefone, endereco } = req.body;
    if (!nome || !dataNascimento || !mae) {
        return res.status(400).json({ message: 'Nome, Data de Nascimento e Nome da Mãe são obrigatórios.' });
    }
    try {
        const [result] = await pool.query(
            'INSERT INTO alunos (nome_aluno, data_nascimento, nome_pai, nome_mae, email, telefone, endereco) VALUES (?, ?, ?, ?, ?, ?, ?)',
            [nome, dataNascimento, pai, mae, email, telefone, endereco]
        );
        res.status(201).json({ message: 'Aluno cadastrado com sucesso!', id: result.insertId });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Erro ao cadastrar aluno.' });
    }
});

app.delete('/alunos/:id', async (req, res) => {
    const { id } = req.params;
    try {
        await pool.query('DELETE FROM matriculas WHERE alunoID = ?', [id]);
        const [result] = await pool.query('DELETE FROM alunos WHERE id = ?', [id]);
        if (result.affectedRows > 0) {
            res.json({ message: 'Aluno excluído com sucesso!' });
        } else {
            res.status(404).json({ message: 'Aluno não encontrado.' });
        }
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Erro ao excluir aluno.' });
    }
});


app.get('/turmas', async (req, res) => {
    try {
        const [rows] = await pool.query('SELECT * FROM turmas');
        res.json(rows);
    } catch (error) {
        res.status(500).json({ message: 'Erro ao buscar turmas.' });
    }
});

app.post('/turmas', async (req, res) => {
    const { nome, codigo, turno } = req.body;
    if (!nome || !codigo || !turno) {
        return res.status(400).json({ message: 'Nome, Código e Turno são obrigatórios.' });
    }
    try {
        const [result] = await pool.query(
            'INSERT INTO turmas (nome_turma, turno, codigo_turma) VALUES (?, ?, ?)',
            [nome, turno, codigo]
        );
        res.status(201).json({ message: 'Turma criada com sucesso!', id: result.insertId });
    } catch (error) {
        console.error(error);
        if (error.code === 'ER_DUP_ENTRY') {
            return res.status(409).json({ message: 'Erro: Código da turma já existe.' });
        }
        res.status(500).json({ message: 'Erro ao criar turma.' });
    }
});


app.listen(port, () => {
    console.log(`🚀 Backend rodando na porta ${port}`);
});