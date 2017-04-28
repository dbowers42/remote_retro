defmodule RemoteRetro.IdeaController do
  use RemoteRetro.Web, :controller

  alias RemoteRetro.Idea

  def create(conn, %{"retro_id" => retro_id} = idea_params) do
    changeset = Idea.changeset(%Idea{}, idea_params)

    case Repo.insert(changeset) do
      {:ok, idea} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", retro_idea_api_path(conn, :show, retro_id, idea))
        |> render("show.json", idea: idea)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(RemoteRetro.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    idea = Repo.get!(Idea, id)
    render(conn, "show.json", idea: idea)
  end

  def update(conn, %{"id" => id, "idea" => idea_params}) do
    idea = Repo.get!(Idea, id)
    changeset = Idea.changeset(idea, idea_params)

    case Repo.update(changeset) do
      {:ok, idea} ->
        render(conn, "show.json", idea: idea)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(RemoteRetro.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    idea = Repo.get!(Idea, id)
    Repo.delete!(idea)

    send_resp(conn, :no_content, "")
  end
end