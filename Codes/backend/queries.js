const { response, request } = require('express')

const Pool = require('pg').Pool
const pool = new Pool({
  user: 'goats',
  host: 'localhost',
  database: 'cqadb',
  password: 'goats',
  port: 5432,
  secure: false
})

const getUsers = (request, response) => {
  pool.query('SELECT id FROM users ORDER BY id ASC', (error, results) => {
    if (error) {
      throw error
    }
    response.status(200).json(results.rows)
  })
}

const getUserById = (request, response) => {
  const id = parseInt(request.params.id)
  // console.log(id)
  pool.query('SELECT * FROM users WHERE id = $1', [id], (error, results) => {
    if (error) {
      throw error
    }
    response.status(200).json(results.rows)
  })
}

const createUser = (request, response) => {
  const name = request.body.name
  const loc = request.body.location
  const aboutMe = request.body.about_me

  pool.query('INSERT INTO users(reputation, display_name, location, about_me, creation_date, last_access_date) \
  VALUES (0, $1, $2, $3, current_timestamp, current_timestamp)', [name, loc, aboutMe], (error, results) => {
    if (error) {
      throw error
    }
    response.status(201).send(`User added with ID: ${results.insertId}`)
  })
}

const updateUser = (request, response) => {
  const id = parseInt(request.params.id)
  const { name, email } = request.body

  pool.query(
    'UPDATE users SET name = $1, email = $2 WHERE id = $3',
    [name, email, id],
    (error, results) => {
      if (error) {
        throw error
      }
      response.status(200).send(`User modified with ID: ${id}`)
    }
  )
}

const deleteUser = (request, response) => {
  const id = parseInt(request.params.id)

  pool.query('DELETE FROM users WHERE id = $1', [id], (error, results) => {
    if (error) {
      throw error
    }
    response.status(200).send(`User deleted with ID: ${id}`)
  })
}

const loginUser = (request, response) => {
  const uname = request.body.username
  const pwd = request.body.password
  // console.log(uname, pwd)
  
  pool.query('SELECT * FROM users WHERE display_name = $1', [uname], (error, results) => {
    if (error) throw error
    if (results.rowCount > 0 && uname == pwd) {
      response.status(200).json({
        'id' : results.rows[0].id,
      })
    } else response.status(204).json({})
  })
}

//to get postModel object details
const getPostById = (request, response) => {
  const id = parseInt(request.params.id)

  pool.query('SELECT * FROM posts WHERE id = $1', [id], (error, results) => {
    if (error) {
      throw error
    }
    response.status(200).json(results.rows)
  })
}

//to get posts created by userId
const getPostByUserId = (request, response) => {
  const id = parseInt(request.params.id)

  pool.query('SELECT id,title,body FROM posts WHERE owner_user_id = $1', [id], (error, results) => {
    if (error) {
      throw error
    }
    response.status(200).json(results.rows)
  })
}

//to get Comments of posts
const getComments = (request, response) => {
  const id = parseInt(request.params.id);

  pool.query('SELECT * FROM comments_users WHERE post_id = $1', [id], (error, results) => {
    if (error) throw error
    response.status(200).json(results.rows);
  })
}

//to delete a post by postID
const deletePost = (request, response) => {
  const id = parseInt(request.params.id);

  pool.query('DELETE FROM posts WHERE id = $1', [id], (error, results) => {
    if (error) throw error
    response.status(200).json(results.rows);
  })
}

const deleteComment = (request, response) => {
  const id = parseInt(request.params.id);

  pool.query('DELETE FROM comments WHERE id = $1', [id], (error, results) => {
    if (error) throw error
    response.status(200).json(results.rows);
  })
}

//for getting all matching tags
const getAllSearchParams = (request, response) => {
  const part = request.body.part
  // console.log(part)
  pool.query("SELECT tag_name as name FROM tags WHERE tag_name LIKE '%'||$1||'%'", [part], (error, results) => {
    if (error) {
      throw error
    }
    response.status(200).json(results.rows)
  })
}

//for getting all matching tags
const getAllUsers = (request, response) => {
  const part = request.body.part
  // console.log(part)
  pool.query("SELECT display_name as name FROM users WHERE display_name LIKE '%'||$1||'%'", [part], (error, results) => {
    if (error) {
      throw error
    }
    response.status(200).json(results.rows)
  })
}

// for finding questions that match users and tags list
const getAllQuestions = (request, response) => {
  const tagList = request.body.tags
  const uname = request.body.uname
  const tsort = request.body.timesort
  const usort = request.body.upsort
  const lim = request.body.limit
  const off = request.body.offset
  var sql = "SELECT * \nFROM posts_users\n";
  if (tagList.length > 0) {
    sql += "WHERE tags LIKE '%"
    sql += tagList.join("%' AND tags LIKE '%")
    sql += "%'\n";
  }
  if (uname != "") {
    if (tagList.length > 0) {
      sql += "AND "
    }
    else {
      sql += "WHERE "
    }
    sql += "display_name = '" + uname + "'\n"
  }
  if (tsort >= 0 || usort >= 0) {
    sql += "ORDER BY "
    if (tsort != -1) {
      if (tsort == 0) {
        sql += " creation_date ASC"
      } else {
        sql += " creation_date DESC" 
      }
    }
    if (usort != -1) {
      if (tsort > -1) sql += ", "
      if (usort == 0) {
        sql += " score ASC"
      } else {
        sql += " score DESC" 
      }
    }
    sql += '\n'
  }
  sql += `LIMIT ${lim} OFFSET ${off}`
  pool.query(sql, (error, results) => {
    // console.log(sql)
    if (error) {
      throw error
    }
    // console.log(results.rows)
    response.status(200).json(results.rows)
  })
}

const getUserPosts = (request, response) => {
  var id = request.params.id
  var limit = request.body.limit
  var offset = request.body.offset
  pool.query('SELECT * from posts_users where owner_user_id = $1 and post_type_id = 1 LIMIT $2 OFFSET $3', [id, limit, offset], (error, results) => {
    if (error) {
      throw error
    }
    response.status(200).json(results.rows)
  })
}

const getUserComments = (request, response) => {
  var id = request.params.id
  var limit = request.body.limit
  var offset = request.body.offset
  pool.query('SELECT * from comments where user_id = $1 LIMIT $2 OFFSET $3', [id, limit, offset], (error, results) => {
    if (error) {
      throw error
    }
    response.status(200).json(results.rows)
  })
}
//to edit a post by postID (to be used in view_post_page.dart)
// const editPost = (request, response) => {
//   const id = parseInt(request.params.id);

//   pool.query('DELETE FROM posts WHERE id = $1', [id], (error, results) => {
//     if (error) throw error
//     response.status(200).json(results.rows);
//   })
// }

// title body owner_user_id owner_display_name tags creation_date 
const createPost = (request, response) => {
  var content_license = "MIT"
  var owner_user_id = request.body.owner_user_id
  var title = request.body.title
  var body = request.body.body
  var tags = request.body.tags
  var id = request.body.post_id ?? -1;

  console.log('All good')
  if (id == -1) {
    pool.query('INSERT INTO posts (owner_user_id, post_type_id, score, title, tags, content_license, body, creation_date) \
     VALUES ($1, 1, 0, $2, $3, $4, $5, current_timestamp)', [owner_user_id, title, tags, content_license, body], (error, results) => {
      if (error) {
        throw error
      }
      response.status(201).send(`Post added with ID: ${results.insertId}`)
    })
  } else {
    pool.query('UPDATE posts SET (owner_user_id, post_type_id, score, title, tags, content_license, body, creation_date) = \
    ($2, 1, 0, $3, $4, $5, $6, current_timestamp) where id = $1', [id, owner_user_id, title, tags, content_license, body], (error, results) => {
      if (error) {
        throw error
      }
      response.status(201).send(`Post updated with ID: ${results.insertId}`)
    })
  }
}

const createComment = (request, response) => {
  var content_license = "MIT"
  var text = request.body.text
  var postId = request.body.post_id
  var userId = request.body.user_id
  var id = request.body.id

  if (id == -1) {
    pool.query('INSERT INTO comments (post_id, user_id, score, content_license, text, creation_date) \
    VALUES ($1, $2, 0, $3, $4, current_timestamp)', [postId, userId, content_license, text], (error, results) => {
      if (error) {
        throw error
      }
      response.status(201).send(`Comment added with ID: ${results.insertId}`)
    })
  } else {
    pool.query('UPDATE comments SET (user_id, score, content_license, text, creation_date) = \
    ($2, 0, $3, $4, current_timestamp) where id = $1', [id, userId, content_license, text], (error, results) => {
      if (error) {
        throw error
      }
      response.status(201).send(`Comment added with ID: ${results.insertId}`)
    })
  }
}

module.exports = {
  getUsers,
  getComments,
  getUserById,
  createUser,
  updateUser,
  deleteUser,
  loginUser,
  getPostById,
  getPostByUserId,
  deletePost,
  // editPost,
  getAllSearchParams,
  getAllUsers,
  getAllQuestions,
  getUserPosts,
  getUserComments,
  createPost,
  createComment,
  deleteComment,
}