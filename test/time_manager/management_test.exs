defmodule TimeManager.ManagementTest do
  use TimeManager.DataCase

  alias TimeManager.Management
   import TimeManager.ManagementFixtures
  import TimeManager.AccountFixtures
    alias TimeManager.Account.User
  setup [:create_user]

  describe "clocks" do
    alias TimeManager.Management.Clock

    import TimeManager.ManagementFixtures


    @invalid_attrs %{status: nil, time: nil}
    
    test "list_clocks/0 returns all clocks", %{user: %User{id: id} = user} do
      valid_attrs = %{status: true, time: ~N[2021-10-25 09:58:00]}
      assert {:ok, %Clock{} = clock} = Management.create_clock(Integer.to_string(user.id), valid_attrs)
      assert Management.list_clocks() == [clock]
    end

    test "get_clock!/1 returns the clock with given id", %{user: %User{id: id} = user} do
      valid_attrs = %{status: true, time: ~N[2021-10-25 09:58:00]}
      assert {:ok, %Clock{} = clock} = Management.create_clock(Integer.to_string(user.id), valid_attrs)
      assert Management.get_clock!(user.id) == [clock]
    end

    test "create_clock/1 with valid data creates a clock", %{user: %User{id: id} = user} do
      valid_attrs = %{status: true, time: ~N[2021-10-25 09:58:00]}

      assert {:ok, %Clock{} = clock} = Management.create_clock(Integer.to_string(user.id), valid_attrs)
      assert clock.status == true
      assert clock.time == ~N[2021-10-25 09:58:00]
    end

    test "create_clock/1 with invalid data returns error changeset", %{user: %User{id: id} = user} do
      assert {:error, %Ecto.Changeset{}} = Management.create_clock(Integer.to_string(user.id),@invalid_attrs)
    end

    # test "update_clock/2 with valid data updates the clock" do
    #   clock = clock_fixture()
    #   update_attrs = %{status: false, time: ~N[2021-10-26 09:58:00]}

    #   assert {:ok, %Clock{} = clock} = Management.update_clock(clock, update_attrs)
    #   assert clock.status == false
    #   assert clock.time == ~N[2021-10-26 09:58:00]
    # end

  #   test "update_clock/2 with invalid data returns error changeset" do
  #     clock = clock_fixture()
  #     assert {:error, %Ecto.Changeset{}} = Management.update_clock(clock, @invalid_attrs)
  #     assert clock == Management.get_clock!(clock.id)
  #   end

  #   test "delete_clock/1 deletes the clock" do
  #     clock = clock_fixture()
  #     assert {:ok, %Clock{}} = Management.delete_clock(clock)
  #     assert_raise Ecto.NoResultsError, fn -> Management.get_clock!(clock.id) end
  #   end

  #   test "change_clock/1 returns a clock changeset" do
  #     clock = clock_fixture()
  #     IO.inspect(clock_fixture)
  #     assert %Ecto.Changeset{} = Management.change_clock(clock)
  #   end
  
  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
  end  
    
  describe "workingtimes" do
    alias TimeManager.Management.WorkingTime

    import TimeManager.ManagementFixtures
    @create_attrs %{
    end: ~N[2021-10-25 09:44:00],
    start: ~N[2021-10-25 09:44:00]
    }

    @invalid_attrs %{end: nil, start: nil}

    test "list_workingtimes/0 returns all workingtimes by user", %{user: %User{id: id} = user} do
      assert {:ok, %WorkingTime{} = working_time} = Management.create_working_time(Integer.to_string(user.id),@create_attrs)
      assert Management.get_working_time!(user.id) == [working_time]
    end

    test "get_working_time!/1 returns the working_time with given id", %{user: %User{id: id} = user} do
      assert {:ok, %WorkingTime{} = working_time} = Management.create_working_time(Integer.to_string(user.id), @create_attrs)
      assert Management.get_working_time_by_user!(user.id, working_time.id) == working_time
    end

    test "create_working_time/1 with valid data creates a working_time", %{user: %User{id: id} = user} do
      assert {:ok, %WorkingTime{} = working_time} = Management.create_working_time(Integer.to_string(user.id), @create_attrs)
      assert working_time.end == ~N[2021-10-25 09:44:00]
      assert working_time.start == ~N[2021-10-25 09:44:00]
    end

    test "create_working_time/1 with invalid data returns error changeset", %{user: %User{id: id} = user} do
      assert {:error, %Ecto.Changeset{}} = Management.create_working_time(Integer.to_string(user.id), @invalid_attrs)
    end

    test "update_working_time/2 with valid data updates the working_time", %{user: %User{id: id} = user} do
      assert {:ok, %WorkingTime{} = working_time} = Management.create_working_time(Integer.to_string(user.id), @create_attrs)
      update_attrs = %{end: ~N[2021-10-26 09:44:00], start: ~N[2021-10-26 09:44:00]}
      assert {:ok, %WorkingTime{} = working_time} = Management.update_working_time(working_time, update_attrs)
      assert working_time.end == ~N[2021-10-26 09:44:00]
      assert working_time.start == ~N[2021-10-26 09:44:00]
    end

    test "update_working_time/2 with invalid data returns error changeset", %{user: %User{id: id} = user} do
      assert {:ok, %WorkingTime{} = working_time} = Management.create_working_time(Integer.to_string(user.id), @create_attrs)
      assert {:error, %Ecto.Changeset{}} = Management.update_working_time(working_time, @invalid_attrs)
      assert working_time == Management.get_working_time_by_user!(user.id, working_time.id)
    end

    test "delete_working_time/1 deletes the working_time", %{user: %User{id: id} = user} do
      assert {:ok, %WorkingTime{} = working_time} = Management.create_working_time(Integer.to_string(user.id), @create_attrs)
      assert {:ok, %WorkingTime{}} = Management.delete_working_time(working_time)
      assert Management.get_working_time_by_user!(user.id, working_time.id) == nil
    end

    test "change_working_time/1 returns a working_time changeset", %{user: %User{id: id} = user} do
      assert {:ok, %WorkingTime{} = working_time} = Management.create_working_time(Integer.to_string(user.id), @create_attrs)
      assert %Ecto.Changeset{} = Management.change_working_time(working_time)
    end
  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
  end
end
