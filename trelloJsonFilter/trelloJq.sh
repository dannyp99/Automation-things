#!/bin/bash
jq -r ' { boards: [.lists[] | { id: .id, name: .name }], cards: [ .cards[] | { name: select(.closed == false).name, boardId: select(.closed == false).idList, restaurants: [] } ]} |
	reduce .cards[] as $card (
      .boards;
      map(if .id == $card.boardId then .restaurants += [$card.name] else . end)
    )
  | map({(.name): .restaurants})' "$1"
