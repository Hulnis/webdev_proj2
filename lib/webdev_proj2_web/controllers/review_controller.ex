defmodule WebdevProj2Web.ReviewController do
  use WebdevProj2Web, :controller

  alias WebdevProj2.Reviews
  alias WebdevProj2.Reviews.Review

  action_fallback WebdevProj2Web.FallbackController

  def index(conn, _params) do
    reviews = Reviews.list_reviews()
    render(conn, "index.json", reviews: reviews)
  end

  def create(conn, %{"review" => review_params}) do
    with {:ok, %Review{} = review} <- Reviews.create_review(review_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", review_path(conn, :show, review))
      |> render("show.json", review: review)
    end
  end

  def show(conn, %{"id" => id}) do
    review = Reviews.get_review!(id)
    render(conn, "show.json", review: review)
  end

  def update(conn, %{"id" => id, "review" => review_params}) do
    review = Reviews.get_review!(id)

    with {:ok, %Review{} = review} <- Reviews.update_review(review, review_params) do
      render(conn, "show.json", review: review)
    end
  end

  def delete(conn, %{"id" => id}) do
    review = Reviews.get_review!(id)
    with {:ok, %Review{}} <- Reviews.delete_review(review) do
      send_resp(conn, :no_content, "")
    end
  end
end
