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