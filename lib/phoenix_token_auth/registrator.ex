defmodule PhoenixTokenAuth.Registrator do
  alias Ecto.Changeset
  import PhoenixTokenAuth.Util

  def changeset(params) do
    Changeset.cast(struct(user_model), params, ~w(email))
    |> set_hashed_password
    |> Changeset.validate_change(:email, &presence_validator/2)
    |> Changeset.validate_unique(:email, on: repo)
  end


  defp set_hashed_password(changeset = %{params: %{"password" => password}}) when password != "" and password != nil do
    hashed_password = crypto_provider.hashpwsalt(password)

    changeset
    |> Changeset.put_change(:hashed_password, hashed_password)
  end
  defp set_hashed_password(changeset) do
    changeset
    |> Changeset.add_error(:password, :required)
  end

  defp presence_validator(field, nil), do: [{field, :required}]
  defp presence_validator(field, ""), do: [{field, :required}]
  defp presence_validator(field, _), do: []

end
