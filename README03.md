## React Todo Part3

+ `app/javascript/components/AddTodo.jsx`を編集<br>

```
import React, { memo, useState } from 'react'
import styled from 'styled-components'
import { toast } from 'react-toastify'
import 'react-toastify/dist/ReactToastify.css'
import { FiSend } from 'react-icons/fi'
import axios from 'axios'

const InputAndButton = styled.div`
  display: flex;
  justify-content: space-between;
  margin-top: 20px;
`

const InputName = styled.input`
  font-size: 20px;
  width: 100%;
  heihgt: 40px;
  padding: 2px 7px;
`

const Button = styled.button`
  font-size: 20px;
  border: none;
  border-radius: 3px;
  margin-left: 10px;
  padding: 2px 10px;
  background: #1e90ff;
  color: #fff;
  text-align: center;
  cursor: pointer;
  ${({ disabled }) =>
    disabled &&
    `
      opacity: 0.5;
      cursor: default;
  `}
`

const Icon = styled.span`
  display: flex;
  align-items: center;
  margin: 0 7px;
`

toast.configure()

const AddTodo = memo((props) => {
  console.log(props)
  const initialTodoState = {
    id: null,
    name: '',
    is_completed: false,
  }

  const [todo, setTodo] = useState(initialTodoState)

  const handleInputChange = (event) => {
    const { name, value } = event.target
    setTodo({ ...todo, [name]: value }) // 今後いろいろと入力できるようにしておく
  }

  const notify = () => {
    toast.success('Todo successfully created!', {
      position: 'bottom-center',
      hideProgressBar: true,
    })
  }

  const saveTodo = () => {
    var data = {
      name: todo.name,
    }

    axios
      .post('/api/v1/todos', data)
      .then((resp) => {
        setTodo({
          id: resp.data.id,
          name: resp.data.name,
          is_completed: resp.data.is_completed,
        })
        notify()
        props.history.push('/todos')
      })
      .catch((e) => {
        console.log(e)
      })
  }
  return (
    <>
      <h1>New Todo</h1>
      <InputAndButton>
        <InputName
          type="text"
          required
          value={todo.name}
          name="name"
          onChange={handleInputChange}
        />
        <Button
          onClick={saveTodo}
          disabled={!todo.name || /^\s*$/.test(todo.name)} // 空白とかの場合はボタンを押させない仕様にしている
        >
          <Icon>
            <FiSend />
          </Icon>
        </Button>
      </InputAndButton>
    </>
  )
})

export default AddTodo
```

## React Todo Part4

+ `src/app/javascript/components/EditTodo.jsx`を編集<br>

```
import React, { memo, useEffect, useState } from 'react'
import styled from 'styled-components'
import { toast } from 'react-toastify'
import 'react-toastify/dist/ReactToastify.css'
import axios from 'axios'

const InputName = styled.input`
  font-size: 20px;
  width: 100%;
  height: 40px;
  padding: 2px 7px;
  margin: 12px 0;
`

const CurrentStatus = styled.div`
  font-size: 19px;
  margin: 8px 0 12px 0;
  font-weight: bold;
`

const IsCompletedButton = styled.button`
  color: #fff;
  font-weight: 500;
  font-size: 17px;
  padding: 5px 10px;
  background: #f2a115;
  border: none;
  border-radius: 3px;
  cursor: pointer;
`

const EditButton = styled.button`
  color: #fff;
  font-size: 17px;
  padding: 5px 10px;
  margin: 0 10px;
  background: #0ac620;
  border: none;
  border-radius: 3px;
  cursor: pointer;
`

const DeleteButton = styled.button`
  color: #fff;
  font-weight: 500;
  font-weight: 17px;
  padding: 5px 10px;
  background: #f54242;
  border: none;
  border-radius: 3px;
  cursor: pointer;
`

toast.configure()

const EditTodo = memo((props) => {
  const initialTodoState = {
    id: null,
    name: '',
    is_completed: false,
  }

  const notify = () => {
    toast.success('Todo successfully updated', {
      position: 'bottom-center',
      hideProgressBar: true,
    })
  }

  const deleteNotify = () => {
    toast.error('Todo successfully deleted', {
      position: 'bottom-center',
      hideProgressBar: true,
    })
  }

  const [currentTodo, setCurrentTodo] = useState(initialTodoState)

  const getTodo = (id) => {
    axios
      .get(`/api/v1/todos/${id}`)
      .then((resp) => {
        setCurrentTodo(resp.data)
      })
      .catch((e) => {
        console.log(e)
      })
  }

  useEffect(() => {
    getTodo(props.match.params.id) // URLからidを取得することができる
  }, [props.match.params.id]) // idが変わった時にudeEffectが走る

  const handleInputChange = (event) => {
    const { name, value } = event.target // カラムはname でvalueはnameの値
    setCurrentTodo({ ...currentTodo, [name]: value })
  }

  const updateIsCompleted = (val) => {
    var data = {
      id: val.id,
      name: val.name,
      is_completed: !val.is_completed,
    }
    axios.patch(`/api/v1/todos/${val.id}`, data).then((resp) => {
      setCurrentTodo(resp.data)
    })
  }

  const updateTodo = () => {
    axios
      .patch(`/api/v1/todos/${currentTodo.id}`, currentTodo)
      .then((resp) => {
        notify()
        props.history.push('/todos') // 遷移先
      })
      .catch((e) => {
        console.log(e)
      })
  }

  const deleteTodo = () => {
    const sure = window.confirm('Are you sure?')
    if (sure) {
      axios
        .delete(`/api/v1/todos/${currentTodo.id}`)
        .then((resp) => {
          props.history.push('/todos')
        })
        .catch((e) => {
          console.log(e)
        })
    }
  }

  return (
    <>
      <h1>Editing Todo</h1>
      <div>
        <div>
          <label htmlFor>Current Name</label>
          <InputName
            type="text"
            name="name"
            value={currentTodo.name}
            onChange={handleInputChange}
          />
          <div>
            <span>Current Status</span>
            <CurrentStatus>
              {currentTodo.is_completed ? 'Completed' : 'Uncompleted'}
            </CurrentStatus>
          </div>
        </div>
        {currentTodo.is_completed ? (
          <IsCompletedButton onClick={() => updateIsCompleted(currentTodo)}>
            Uncompleted
          </IsCompletedButton>
        ) : (
          <IsCompletedButton onClick={() => updateIsCompleted(currentTodo)}>
            Completed
          </IsCompletedButton>
        )}
        <EditButton onClick={updateTodo}>Update</EditButton>
        <DeleteButton onClick={deleteTodo}>Delete</DeleteButton>
      </div>
    </>
  )
})

export default EditTodo
```