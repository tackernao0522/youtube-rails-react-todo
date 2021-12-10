## React Todo Part2

+ `app/javascript/components`ディレクトリを作成<br>

+ `app/javascript/components/AddTodo.jsx`コンポーネントを作成<br>

+ `app/javascript/components/App.jsx`コンポーネントを作成<br>

+ `app/javascript/components/EditTodo.jsx`コンポーネントを作成<br>

+ `app/javascript/components/TodoList.jsx`コンポーネントを作成<br>

+ `app/javascript/components/App.css`ファイルを作成<br>

```
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  min-height: 100vh;
  color: rgb(1, 1, 1);
}

h1 {
  text-align: center;
  margin-top: 30px;
  margin-bottom: 15px;
}

a {
  text-decoration: none;
  color: rgb(1, 1, 1);
}

input:focus {
  outline: 0;
}
```

+ `app/javascript/packs/index.jsx`を編集<br>

```
import React from 'react'
import ReactDOM from 'react-dom'
import { BrowserRouter } from 'react-router-dom'
import App from '../components/App'

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <BrowserRouter>
      <App />
    </BrowserRouter>,
    document.querySelector('#root'),
  )
})
```

+ `app/javascript/components/AddTodo.jsx`を編集<br>

`rfceを打つと自動的にコード補完してくれる`<br>

```
import React from 'react'

const AddTodo = () => {
  return (
    <div>
      AddTodo
    </div>
  )
}

export default AddTodo
```

+ `app/javascript/components/App.jsx`を編集<br>

```
import React from 'react'

const App = () => {
  return (
    <div>

    </div>
  )
}

export default App
```

+ `app/javascript/components/EditTodo.jsx`を編集<br>

```
import React from 'react'

const EditTodo = () => {
  return (
    <div>
      EditTodo
    </div>
  )
}

export default EditTodo
```

+ `app/javascript/components/TodoList.jsx`を編集<br>

```
import React from 'react'

const TodoList = () => {
  return (
    <div>
      TodoList
    </div>
  )
}

export default TodoList
```

+ `app/javascript/components/App.jsx`を編集<br>

```
import React from 'react'
import './App.css'
import styled from 'styled-components'
import { Link, Route, Switch } from 'react-router-dom'
import TodoList from './TodoList'
import AddTodo from './AddTodo'
import EditTodo from './EditTodo'

const Nabvar = styled.nav`
  background: #dbfffe;
  min-height: 8vh;
  display: flex;
  justify-content: space-around;
  align-items: center;
`

const Logo = styled.div`
  font-weight: bold;
  font-size: 23px;
  letter-spacing: 3px;
`

const NavItems = styled.ul`
  display: flex;
  width: 400px;
  max-width: 40%;
  justify-content: space-around;
  list-style: none;
`

const NavItem = styled.li`
  font-size: 19px;
  font-weight: bold;
  opacity: 0.7;
  &:hover {
    opacity: 1;
  }
`

const Wrapper = styled.div`
  width: 700px;
  max-width: 85%;
  margin: 20px auto;
`

const App = () => {
  return (
    <>
      <Nabvar>
        <Logo>TODO</Logo>
        <NavItems>
          <NavItem>
            <Link to="/todos">Todos</Link>
          </NavItem>
          <NavItem>
            <Link to="/todos/new">Add New Todo</Link>
          </NavItem>
        </NavItems>
      </Nabvar>
      <Wrapper>
        <Switch>
          <Route exact path="/todos" component={TodoList} />
          <Route exact path="/todos/new" component={AddTodo} />
          <Route path="/todos/:id/edit" component={EditTodo} />
        </Switch>
      </Wrapper>
    </>
  )
}

export default App
```

+ `$ yarn add axios --save`を実行<br>

+ `app/javascript/components/TodoList.jsx`を編集<br>

```

```