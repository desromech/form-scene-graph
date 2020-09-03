Extension { #name : #LazyListMorph }

{ #category : #'*FormSceneGraph-Morphic' }
LazyListMorph >> buildBackgroundSceneGraphForRow: row with: builder color: col [
	| frame  |
	"shade the background darker, if this row is selected"
 	frame := self selectionFrameForRow: row.
	^ builder solidRectangle: frame color: col
]

{ #category : #'*FormSceneGraph-Morphic' }
LazyListMorph >> buildBackgroundSceneGraphForSearchedRow: row with: builder [
	^ self buildBackgroundSceneGraphForRow: row with: builder color: listSource secondarySelectionColor
]

{ #category : #'*FormSceneGraph-Morphic' }
LazyListMorph >> buildBackgroundSceneGraphForSelectedRow: row with: builder [
	^ self buildBackgroundSceneGraphForRow: row with: builder color: listSource selectionColorToUse
]

{ #category : #'*FormSceneGraph-Morphic' }
LazyListMorph >> buildItemSceneGraph: item atRow: row with: builder [
	| drawBounds itemColor backgroundColor result |
	drawBounds := self drawBoundsForRow: row.
	itemColor := self colorForRow: row.
	backgroundColor := self backgroundColorForRow: row.
	result := item listBuildSceneGraphWith: builder atRow: row bounds: drawBounds color: itemColor
		backgroundColor: backgroundColor from: self.
	row = self mouseDownRow ifTrue: [
		result := result , (builder frameRectangle: (self selectionFrameForRow: row) width: 1
				colors: {itemColor. (Color transparent)}
				dashes: #(1 1))
	].
		
	^ result
]

{ #category : #'*FormSceneGraph-Morphic' }
LazyListMorph >> buildSceneGraphNodeWith: builder [
	| result |
	listItems isEmpty ifTrue: [ ^ builder null ].

	result := builder null.
	1 to: listItems size do: [:row |
		(listSource itemSelectedAmongMultiple: row)
			ifTrue: [ result := result , (self buildBackgroundSceneGraphForSelectedRow: row with: builder )]
			ifFalse: [
				(listSource searchedElement = row)
					ifTrue: [ result := result , (self buildBackgroundSceneGraphForSearchedRow: row with: builder)]
					ifFalse: [
						(listSource backgroundColorFor: row)
							ifNotNil: [:col |
								result := result , (self buildBackgroundSceneGraphForRow: row with: builder color: col) ]]].
					
			selectedRow = row ifTrue: [ result := result , (self buildSelectionSceneGraphWith: builder) ].
			(listSource separatorAfterARow: row) ifTrue: [ result := result , (self buildSeparatorSceneGraphAfter: row with: builder) ].
			result := result , (self buildItemSceneGraph: (self item: row) atRow: row with: builder)
	].
	^ result
]

{ #category : #'*FormSceneGraph-Morphic' }
LazyListMorph >> buildSelectionSceneGraphWith: builder [
	selectedRow ifNil: [ ^self ].
	selectedRow = 0 ifTrue: [ ^self ].
	^ self buildBackgroundSceneGraphForSelectedRow: selectedRow with: builder
]

{ #category : #'*FormSceneGraph-Morphic' }
LazyListMorph >> buildSeparatorSceneGraphAfter: aRow with: builder [
	| height separatorColor frame rectangle |
	height := listSource separatorSize.
	separatorColor := listSource separatorColor.
	frame := self selectionFrameForRow: aRow.
	rectangle := (frame left@(frame bottom - height)) corner: (frame right@frame bottom).

	^ builder solidRectangle: rectangle color: separatorColor
]
