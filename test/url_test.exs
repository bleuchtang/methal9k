defmodule Hal.Dispatcher do
  use ExUnit.Case, async: true

  import Mock

  test "one line with maj <title>" do
    with_mocks([{HTTPoison, [],
                 [get: fn(_url) -> """
                 <!DOCTYPE html>
                 <html lang="en">
                 <head>
                 <meta charset="utf-8">
                 <title>w1gz/methal9k: Home of Meta Hal 9000 -- IRC bot &amp; more</TITLE>
                 </head>
                 <body>
                 something
                 </body>
                 </html>
                 """
                 end]},
                {Hal.Tool, [],
                 [terminate: fn(_whom, _pid, _uid, answers) ->
                   IO.puts(answers)
                 end]}]) do

      Hal.Plugin.Url.preview(None, ["https://github.com/w1gz/"], None)

    end

  end

  # test "multiline <title>" do
  #   with_mock HTTPoison,
  #     [get: fn(_url) -> """
  #     <!DOCTYPE html>
  #     <html lang="en">
  #     <head>
  #     <meta charset="utf-8">
  #     <title>w1gz/methal9k: Home
  #     of Meta Hal 9000
  #     --
  #     IRC bot &amp; more</title>
  #     </head>
  #     <body>
  #     something
  #     </body>
  #     </html>
  #     """
  #     end] do
  #   end

  # end

  # test "greedy <title>" do
  #   with_mock HTTPoison,
  #     [get: fn(_url) -> """
  #     <!DOCTYPE html>
  #     <html lang="en">
  #     <head>
  #     <title>w1gz/methal9k: Home of Meta Hal 9000 -- IRC bot &amp; more</title>
  #     <meta charset="utf-8">
  #     <title>w1gz/methal9k: Home of Meta Hal 9000 -- IRC bot &amp; more</title>
  #     </head>
  #     <body>
  #     <title>w1gz/methal9k: Home of Meta Hal 9000 -- IRC bot &amp; more</title>
  #     </body>
  #     </html>
  #     """
  #     end] do
  #   end

  # end

  # test "No title" do
  #   with_mock HTTPoison,
  #     [get: fn(_url) -> """
  #     <!DOCTYPE html>
  #     <html lang="en">
  #     <head>
  #     <meta charset="utf-8">
  #     </head>
  #     <body>
  #     something
  #     </body>
  #     </html>
  #     """
  #     end] do
  #   end

end
