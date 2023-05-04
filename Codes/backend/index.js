const express = require('express')
const bodyParser = require('body-parser')
const app = express()
const db = require('./queries')
const port = 3000
const cors = require('cors')

app.use(cors())

app.use(bodyParser.json())
app.use(
  bodyParser.urlencoded({
    extended: true,
  })
)

app.get('/', (req, res) => {
  res.render('login');
})

app.get('/login', (req,res) => {
  res.render('login');
})

app.get('/users', db.getUsers)
app.get('/users/:id', db.getUserById)
app.post('/users', db.createUser)
app.put('/users/:id', db.updateUser)
app.delete('/users/:id', db.deleteUser)
app.post('/users/login', db.loginUser)
app.get('/post/:id', db.getPostById)
app.get('/post/:id/comments', db.getComments)
app.post("/users/:id/posts", db.getUserPosts)
app.post("/users/:id/comments", db.getUserComments)
app.post('/tagsearch', db.getAllSearchParams)
app.post('/postsearch', db.getAllQuestions)
app.post('/usersearch', db.getAllUsers)
app.delete('/deletepost/:id', db.deletePost)
app.delete('/deletecomment/:id', db.deleteComment)
app.put('/updatepost', db.createPost)
app.put('/updatecomment', db.createComment)
app.put('/createuser', db.createUser)

app.listen(port, () => {
  console.log(`App running on port ${port}.`)
})