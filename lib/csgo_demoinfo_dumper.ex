defmodule CsgoDemoinfoDumper do
  require CsgoDemoinfoDumper.Header
  @moduledoc """
  A elxiir module that will handle the reading of
  csgo demo files.
  """

  def open_demo(demo_file) do
    File.open demo_file, [:read]
  end

  def read_header(demo), do: read_bytes(demo, 1072)

  def read_standard(demo) do
    length = read_bytes(demo, 4) |> get_int32
    read_bytes(demo, length)
  end

  def read_cmd(demo), do: read_bytes(demo, 6)

  def parse_cmd(<<cmd::binary - size(1), tick::binary - size(4), player_slot::binary - size(1)>>) do
    IO.puts(cmd)
    IO.puts(get_int32(tick))
    IO.puts(player_slot)
  end

  def parse_header(<<"HL2DEMO", 0x00, demo_protocol::binary - size(4), network_protocol::binary - size(4), server_name::binary - size(260), client_name::binary - size(260), map_name::binary - size(260), game_directory::binary - size(260), playback_time::binary - size(4), ticks::binary - size(4), frames::binary - size(4), sign_on_length::binary - size(4)>>) do
    %CsgoDemoinfoDumper.Header{
      demo_protocol: get_int32(demo_protocol),
      network_protocol: get_int32(network_protocol),
      server_name: server_name,
      client_name: client_name,
      map_name: map_name,
      game_directory: game_directory,
      playback_time: get_float32(playback_time),
      ticks: get_int32(ticks),
      frames: get_int32(frames),
      sign_on_length: get_int32(sign_on_length)
    }
  end

  def parse_frame(<<server_frame::binary - size(4), client_frame::binary - size(4), sub_packet_size::binary - size(4), data::binary>>) do
    IO.puts(get_int32(server_frame))
    IO.inspect(client_frame)
    IO.puts(get_int32(client_frame))
    IO.puts(get_int32(sub_packet_size))
    IO.inspect(data)
  end


  def valid_demo(demo) do
    header = read_header(demo)
    header == <<72, 76, 50, 68, 69, 77, 79, 0>>
  end

  def read_int(demo), do: read_bytes(demo, 4) |> get_int32

  def read_bytes(demo, bytes) do
    IO.binread(demo, bytes)
  end

  def get_int32(<<num::little-signed-integer-size(32)>>), do: num
  def get_float32(<<num::little-signed-float-size(32)>>), do: num

end
