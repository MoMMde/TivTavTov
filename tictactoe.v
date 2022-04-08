module main

import os

const (
	grid_length       = 9 // For design purposes this will be rendered times 2
	grid_width        = 6
	length_until_win  = 3
	max_players       = 2
	player_characters = r'123456789abcdefghijklmnopqrstuvwxyz' // players will use [players length - 1]
	unused            = ' '
	vertical_split    = '|'
	horizontal_split  = '-'
	corner_split      = '+'
)

//   |11|
// --+--+--
//   |22|
// --+--+--
//   |  |

struct Player {
	mut:
		name string
		symbol string
		has_won bool
		has_lost bool
		has_drawn bool
		is_turn bool
}

struct Slot {
	x int
	y int
	mut:
		symbol string
}

struct Game {
	mut:
		players []Player
		grid [][]Slot
		current_player int
}

fn print_grid(game [][]Slot) {
	for width in 0 .. game.len {
		for length in 0 .. game[width].len {
			print(game[width][length].symbol)
			print(game[width][length].symbol)
			if length != game[width].len-1 {
				print(vertical_split)
			}
		}
		print('\n')
		if width != game.len-1 {
			for width_2 in 0 .. game[width].len {
				print(horizontal_split)
				print(horizontal_split)
				if width_2 != game[width].len-1 {
					print(corner_split)
				}
			}
		}
		print('\n')
	}
}

fn generate_slots() [][]Slot {
	mut slots := [][]Slot{
		len: grid_width,
		init: []Slot{
			len: grid_length
		}
	}
	for i in 0 .. grid_width {
		for j in 0 .. grid_length {
			slots[i][j] = Slot{
				x: i, 
				y: j, 
				symbol: unused
			}
		}
	}
	return slots
}

fn generate_players() []Player {
	mut players := []Player{}
	for i in 0 .. max_players {
		players.insert(i, Player{
			name: 'Player ${i + 1}',
			symbol: player_characters[i].ascii_str(), 
			has_won: false, 
			has_lost: false, 
			has_drawn: false, 
			is_turn: false
		})
	}
	return players
}

fn get_x(name string, max int) int {
	slot_x := os.input("Where do you want to place your next piece ($name)").int() - 1
	if slot_x >= max || slot_x < 0 {
		println("Invalid $name, please try again")
		return get_x(name, max)
	}
	return slot_x
}

fn get_location(game Game) (int, int) {
	x := get_x('Width', grid_width)
	y := get_x('Length', grid_length)
	if game.grid[x][y].symbol != unused {
		println("Slot is already taken, please try again")
		return get_location(game)
	}
	return x, y
}

// TODO: Implement a check for a win
fn check_if_win(mut game Game) {
	println("TODO: Check if win")
}

fn run_tick(mut game Game) {
	print_grid(game.grid)
	match game.players.filter(it.has_won == true).len > 0 {
		true {
			println("We got an Winner!")
			exit(0)
		}
		false {
			println("Now Turns: ${game.players[game.current_player].name}")
			x := get_x('Width', grid_width)
			y := get_x('Length', grid_length)
			if game.grid[x][y].symbol == unused {
				game.grid[x][y].symbol = game.players[game.current_player].symbol
			} else {
				println("Slot is already taken, please try again")
				run_tick(mut game)
				return
			}
			check_if_win(mut game)
			if game.current_player == game.players.len-1 {
				game.current_player = 0
			} else {
				game.current_player = game.current_player + 1
			}
		}
	}
	run_tick(mut game)
}

println('testing tic tac toe - written in V by MoMMde')

mut game := Game {
	players: generate_players(),
	grid: generate_slots()
}

println('== Starting game ==')
println('Players = ${game.players.len}')
println('Grid = ${game.grid[0].len}x${game.grid.len}')

run_tick(mut game)
