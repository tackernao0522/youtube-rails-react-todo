class Api::V1::TodosController < ApplicationController
  def index
    todos = Todo.order(updated_at: :desc)
    render json: todos
  end

  def show
    todo = Todo.find(params[:id])
    render json: todo
  end

  def create
    todo = Todo.new(todo_params)
    if todo.save
      render json: todo
    else
      render json: todo.errors, status: 422
    end
  end

  def update
    todo = Todo.find(params[:id])
    if todo.update(todo_params)
      render json: todo
    else
      render json: todo.errors, status: 422
    end
  end

  def destory
    if Todo.destory(params[:id])
      head :no_content
    else
      render json: { error: "Failed to destory" }, status: 422
    end
  end

  def destory_all
    if Todo.destory_all
      head :no_content
    else
      render json: { error: "Failed to destory" }, status: 422
    end
  end

  private
  def todo_params
    params.require(:todo).permit(:name, :is_completed)
  end
end
