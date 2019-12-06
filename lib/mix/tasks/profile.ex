defmodule Mix.Tasks.Exprof do
  @shortdoc "Profile heavy tasks using ExProf"
  use Mix.Task
  import ExProf.Macro
  import Advent2019Web.Day06Controller

  def run(_mix_args) do
    profile(do: day6part1())
  end

  defp day6part1() do
    input = [
      "COM)B",
      "B)C",
      "C)D",
      "D)E",
      "E)F",
      "B)G",
      "G)H",
      "D)I",
      "E)J",
      "J)K",
      "K)L",
      "K)F6J",
      "F6J)1YB",
      "6LV)SG3",
      "K7G)GD2",
      "JC1)Y2W",
      "43D)SP2",
      "YQV)JKG",
      "TD4)7SZ",
      "H8T)43D",
      "T1S)H8Y",
      "1BW)H7F",
      "PDV)93Q",
      "2HK)Z93",
      "37L)1FF",
      "35Y)MZH",
      "7NY)DWF",
      "YLS)5B6",
      "N66)QLD",
      "T9K)TMS",
      "JZF)7TC",
      "9QD)YRG",
      "5T2)CYY",
      "DBP)FG7",
      "JVN)N7N",
      "Q78)K9T",
      "6CZ)D66",
      "WD3)LNP",
      "7YB)Y9T",
      "Z3S)115",
      "2PD)RC7",
      "XZS)DZD",
      "PCP)3YG",
      "QYH)3CV",
      "F3M)1SZ",
      "37W)C4L",
      "W1Y)T5F",
      "S9V)TD7",
      "L52)81R",
      "7F1)45V",
      "858)YN9",
      "4JB)RMY",
      "NL4)F8R",
      "V6D)KPP",
      "ZMR)KXH",
      "X7Y)N3G",
      "TRT)W5B",
      "FHH)MNV",
      "725)W9Y",
      "QYG)D7S",
      "LQX)ZQK",
      "KTL)G6X",
      "Z93)GZS",
      "W28)BFC",
      "PR1)9B6",
      "MNX)Y76",
      "YZG)1WK",
      "X6S)H9M",
      "GPY)HLS",
      "7XR)G7Q",
      "5B1)MVF",
      "3GK)XTS",
      "KFK)36G",
      "5B6)PD9",
      "TL4)NXV",
      "265)84G",
      "Z5T)B78",
      "JBB)LG9",
      "GLM)1H1",
      "H6F)P9N",
      "DZP)MFM"
    ]

    input
    |> represent_as_map
    |> transitive_closure
    |> count_orbits
  end
end
