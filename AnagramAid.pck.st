'From Cuis 4.2 of 25 July 2013 [latest update: #2463] on 30 August 2015 at 11:14:47.699556 am'!
'Description An aid for solving anagrams with different behavior for short and long anagrams. With a long anagram, random re-arrangements are listed as clues. One may remove letters and study the remainder. Removed letters can be returned. Short anagrams produce a list of permutations.'!
!provides: 'AnagramAid' 1 7!
!classDefinition: #Anagram category: #AnagramAid!
TextModel subclass: #Anagram
	instanceVariableNames: 'board clues count jmb omitted omit'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'AnagramAid'!
!classDefinition: 'Anagram class' category: #AnagramAid!
Anagram class
	instanceVariableNames: ''!

!classDefinition: #AnagramWindow category: #AnagramAid!
SystemWindow subclass: #AnagramWindow
	instanceVariableNames: 'buttonPane statusString cluesString'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'AnagramAid'!
!classDefinition: 'AnagramWindow class' category: #AnagramAid!
AnagramWindow class
	instanceVariableNames: ''!


!Anagram commentStamp: 'dhn 1/26/2015 16:26' prior: 0!
Provide the behavior for operating Anagram Aid.!

!AnagramWindow commentStamp: 'dhn 1/26/2015 18:39' prior: 0!
The window for Anagram Aid.!

!TextComposition methodsFor: '*AnagramAid' stamp: 'dhn 8/26/2015 18:32'!
editor

	^ editor! !

!Anagram methodsFor: 'operating' stamp: 'dhn 8/29/2015 20:12'!
atRandom
	"Display randomly selected clues"
	| set temp |
	set _ Set new.
	self class cluesToDisplay timesRepeat: [set add: jmb shuffled].	"avoid duplicates"
	temp _ String new writeStream.
	set do: [:ea |
		temp
			nextPutAll: ea;
			nextPutAll: self separators].
	self board cluesString actualContents: temp contents.
	self board cluesFont.
	count _ count + set size! !

!Anagram methodsFor: 'accessing'!
board
	^ board.! !

!Anagram methodsFor: 'accessing' stamp: 'dhn 1/26/2015 18:11'!
board: anObject
	"Set the value of board to anObject"
	board _ anObject! !

!Anagram methodsFor: 'accessing'!
clues
	^ clues.! !

!Anagram methodsFor: 'accessing' stamp: 'dhn 1/26/2015 18:09'!
clues: aString
	"Set the value of clues to aString"
	clues _ aString.! !

!Anagram methodsFor: 'operating' stamp: 'dhn 1/28/2015 11:23'!
configureButtons
	"Choose which buttons to show based on the sizes of #jmb and #omitted"
	self jmb size > self class permuteLimit
		ifTrue: [
			self omitted size isZero
				ifTrue: [ self putButtons: {self newButton. self moreButton. self withoutButton} ]
				ifFalse: [ self putButtons: {self newButton. self moreButton. self withoutButton. self revertButton} ]]
		ifFalse: [
			self omitted size isZero
				ifTrue: [ self putButtons: {self newButton} ]
				ifFalse: [ self putButtons: {self newButton. self withoutButton. self revertButton} ]].! !

!Anagram methodsFor: 'accessing'!
count
	^ count.! !

!Anagram methodsFor: 'accessing' stamp: 'dhn 1/26/2015 18:10'!
count: aNumber
	"Set the value of count to aNumber"
	count _ aNumber! !

!Anagram methodsFor: 'operating' stamp: 'dhn 2/1/2015 15:51'!
entry
	"Acquire a new anagram"
	| ans |
	ans _ FillInTheBlankMorph
		request: 'Enter the Anagram'
		initialAnswer: ''.
	ans isEmpty ifFalse: [
		self jmb: ans asUppercase.
		count _ 0.
		self omitted: String new.
		self more].
	self configureButtons.! !

!Anagram methodsFor: 'initialize-release' stamp: 'dhn 8/25/2015 19:59'!
initialize
	super initialize! !

!Anagram methodsFor: 'accessing'!
jmb
	jmb ifNil: [ jmb _ '' ].
	^ jmb.! !

!Anagram methodsFor: 'accessing' stamp: 'dhn 1/26/2015 18:07'!
jmb: aString
	"Set the value of jmb to aString"
	jmb _ aString.! !

!Anagram methodsFor: 'operating' stamp: 'dhn 8/29/2015 20:16'!
letterCount: aString
	"Answer a print string showing the number of times letters appear in aString"
	| dix sorted str |
	dix _ Dictionary new.
	aString sort do: [ :ea | | sym |
		sym _ ea asSymbol.
		(dix includesKey: sym)
			ifTrue: [dix at: sym put: (dix at: sym) + 1]
			ifFalse: [dix at: sym	put: 1]].
	str _ String new writeStream newLine.
	sorted _ dix keys asSortedCollection.
	sorted do: [ :char |
		str nextPutAll: char printString;
			nextPutAll: '->';
			nextPutAll: (dix at: char) printString; space].
	^ str contents.! !

!Anagram methodsFor: 'operating' stamp: 'dhn 8/29/2015 19:48'!
lettersOmitted
	"Answer a print string showing the letters omitted from the anagram"
	| str |
	str _ String new writeStream.
	self omitted isEmpty 
		ifTrue: [^ '']
		ifFalse: [
			str
				nextPutAll: 'Without: ';
				nextPutAll: omitted; newLine.
			^ str contents]! !

!Anagram methodsFor: 'operating' stamp: 'dhn 8/26/2015 18:02'!
more
	"Display the next set of clues, either at random or permuted"
	jmb size > self class permuteLimit
		ifTrue: [ self atRandom ]
		ifFalse: [ self permuted ].
	self board adjustExtentFor: jmb.
	self showStatistics! !

!Anagram methodsFor: 'initialize-release' stamp: 'dhn 1/26/2015 18:16'!
moreButton
	"Answer the More button"
	^ PluggableButtonMorph new
		model: self;
		label: 'More';
		action: #more;
		color: Color white;
		setBalloonText: 'Displays additional
letter combinations.'.! !

!Anagram methodsFor: 'initialize-release' stamp: 'dhn 1/30/2015 09:17'!
newButton
	"Answer the New button"
	^ PluggableButtonMorph new
		model: self;
		label: 'New';
		action: #entry;
		color: Color white;
		setBalloonText: 'Asks for letters of a new anagram,
then displays different combinations of those letters.'.! !

!Anagram methodsFor: 'accessing'!
omit
	^ omit.! !

!Anagram methodsFor: 'accessing' stamp: 'dhn 1/26/2015 18:06'!
omit: aString
	"Set the value of omit to aString"
	omit _ aString.! !

!Anagram methodsFor: 'accessing' stamp: 'dhn 1/28/2015 11:24'!
omitted
	omitted ifNil: [ omitted _ '' ].
	^ omitted! !

!Anagram methodsFor: 'accessing' stamp: 'dhn 1/26/2015 18:05'!
omitted: aString
	"Set the value of omitted to aString"
	omitted _ aString.! !

!Anagram methodsFor: 'operating' stamp: 'dhn 8/29/2015 20:13'!
permuted
	"Display a set of permuted clues"
	| clueSet clue str |
	clue _ String new writeStream.
	clueSet _ Set new.
	(1 to: jmb size) permutationsDo: [ :letter |
		clue reset.
		(1 to: jmb size) do: [ :ix |
			clue nextPut: (jmb at: (letter at: ix))].
		clueSet add: clue contents].	"avoid duplicates"
	str _ String new writeStream.
	clueSet do: [:ea |
		str
			nextPutAll: ea;
			nextPutAll: self separators].
	self board cluesString actualContents: str contents.
	self board cluesFont.
	count _ count + clueSet size! !

!Anagram methodsFor: 'initialize-release' stamp: 'dhn 1/26/2015 18:19'!
putButtons: aCollection
	"Remove all buttons then add all the buttons in aCollection"
	self board
		removeButtons;
		addAllButtons: aCollection.! !

!Anagram methodsFor: 'operating' stamp: 'dhn 1/29/2015 15:51'!
revert
	"Return the omitted characters to the anagram"
	jmb _ jmb , omitted.
	self omitted: String new.
	self configureButtons.
	self more! !

!Anagram methodsFor: 'initialize-release' stamp: 'dhn 1/26/2015 18:15'!
revertButton
	"Answer the Revert button"
	^ PluggableButtonMorph new
		model: self;
		label: 'Revert';
		action: #revert;
		color: Color white;
		setBalloonText: 'Re-inserts removed characters,
then displays the original set.'.! !

!Anagram methodsFor: 'operating' stamp: 'dhn 8/26/2015 13:40'!
separators
	"Answer the string which separates the clues"
	^ '  '! !

!Anagram methodsFor: 'operating' stamp: 'dhn 8/25/2015 20:43'!
showStatistics
	"Update the status area"
	| str |
	str _ String new writeStream
		nextPutAll: self lettersOmitted;
		nextPutAll: 'Number of clues so far = ';
		nextPutAll: count asString;
		newLine;
		nextPutAll: 'characters = ';
		nextPutAll: self jmb size asString;
		nextPutAll: (self letterCount: jmb);
		newLine.
	self board statusString actualContents: str contents.! !

!Anagram methodsFor: 'operating' stamp: 'dhn 8/29/2015 20:21'!
without
	"Remove letters, if specified, from the anagram and produce more clues"
	| col what str |
	what _ FillInTheBlankMorph
		request: 'Enter the letters to be omitted.'
		initialAnswer: ''.
	what isEmpty ifFalse: [
		col _ self jmb asOrderedCollection.
		self omit: what asUppercase asOrderedCollection.
		self omit do: [ :ea |
			(col includes: ea) ifTrue: [
				col remove: ea.
				self omitted: self omitted, ea asString]].
		str _ String new writeStream.
		col do: [ :remainingLetter |
			str nextPut: remainingLetter].
		self jmb: str contents;
			configureButtons;
			more]! !

!Anagram methodsFor: 'initialize-release' stamp: 'dhn 1/26/2015 18:14'!
withoutButton
	"Answer the Without button"
	^ PluggableButtonMorph new
		model: self;
		label: 'Without';
		action: #without;
		color: Color white;
		setBalloonText: 'Removes characters,
then re-displays what is left.'.! !

!Anagram class methodsFor: 'initialization' stamp: 'dhn 3/3/2015 14:37'!
cluesToDisplay
	"Answer the number of clues to display at one time for large anagrams"
	^ 100! !

!Anagram class methodsFor: 'initialization' stamp: 'dhn 1/26/2015 16:24'!
permuteLimit
	"Answer the maximum size of the anagram which will be permuted"
	^ 5! !

!AnagramWindow methodsFor: 'initialization' stamp: 'dhn 1/26/2015 18:44'!
addAllButtons: aCollection
	"Add all the buttons in aCollection to the button pane"
	aCollection do: [ :ea |
		buttonPane
			addMorph: ea
			proportionalWidth: AnagramWindow buttonWidth]! !

!AnagramWindow methodsFor: 'resizing' stamp: 'dhn 8/30/2015 11:05'!
adjustExtentFor: aString
	"Set width of extent  such that clues of aString appear in columns"
	| innerMorph charPixels oldExtent newWidth scrollPixels nl pad clue cols |
	
	innerMorph _ self findDeepSubmorphThat: [:s | s is: #InnerTextMorph] ifAbsent: [^ nil].
	charPixels _ innerMorph textComposition editor lastFont widthOf: $M.		"width per character"
	oldExtent _ self morphExtent.
	
	(innerMorph owner verticalScrollBar valueOfProperty: #visible)
		ifTrue: [scrollPixels _ 13]		"scroll bar width guesstimate"
		ifFalse: [scrollPixels _ 0].
		
	nl _ charPixels.			"new line width"
	pad _ charPixels * self model separators size.	"padding width"
	clue _ charPixels * aString size.		"clue width"
	
	cols _ ((oldExtent x) + pad - nl - scrollPixels) / (clue + pad).
	cols _ 3 max: cols floor.		"at least 3 columns"
	
	newWidth _ (cols * (clue + pad)) + nl + scrollPixels.
	
	self morphExtent: newWidth @ (oldExtent y).! !

!AnagramWindow methodsFor: 'initialization' stamp: 'dhn 8/29/2015 20:39'!
buildMorphicWindow
	"Specify the layout for the Anagram Assistant window"
	| status cluesMorph statusMorph clues |
	
	status _ LayoutMorph newRow
		name: 'status area';
		addMorph: (statusMorph _ TextModelMorph 
			withModel: (statusString _ TextModel withText: 'Status Area')).
	statusMorph name: #status.
			
	buttonPane _ LayoutMorph newRow
		name: #buttons;
		padding: #center; "#center causes the buttons to be centered in the row"
		color: Color lightGreen.
	
	clues _ LayoutMorph newRow
		name: 'clue area';
		addMorph: (cluesMorph _ TextModelMorph 
			withModel: (cluesString _ TextModel withText: 'Clues Area')).
	cluesMorph name: #clues.
			
	statusMorph askBeforeDiscardingEdits: false;
		wrapFlag: true.
			
	cluesMorph askBeforeDiscardingEdits: false;
		wrapFlag: true.
		
	self layoutMorph
			addMorph: status proportionalHeight: 0.15;		
			addAdjusterAndMorph: buttonPane proportionalHeight: 0.05;		
			addAdjusterAndMorph: clues proportionalHeight: 0.80.
			
	model putButtons: {model newButton}
! !

!AnagramWindow methodsFor: 'accessing' stamp: 'dhn 1/26/2015 18:41'!
buttonPane
	^ buttonPane! !

!AnagramWindow methodsFor: 'accessing' stamp: 'dhn 8/25/2015 21:07'!
cluesFont
	"If the font 'DejaVu Sans Mono' is available, use it for the clues"
	
	AbstractFont familyNames 
		detect: [:f | f = 'DejaVu Sans Mono'] 
			ifNone: [^ self].
	self cluesString actualContents 
		font: (AbstractFont familyName: 'DejaVu Sans Mono' aroundPointSize: 10).! !

!AnagramWindow methodsFor: 'accessing' stamp: 'dhn 1/26/2015 18:41'!
cluesString
	^ cluesString! !

!AnagramWindow methodsFor: 'initialization' stamp: 'dhn 8/25/2015 17:18'!
initialize
	super initialize! !

!AnagramWindow methodsFor: 'initialization' stamp: 'dhn 1/26/2015 18:44'!
removeButtons
	"Remove all buttons from the button pane"
	buttonPane removeAllMorphs.! !

!AnagramWindow methodsFor: 'accessing' stamp: 'dhn 1/26/2015 18:41'!
statusString
	^ statusString! !

!AnagramWindow class methodsFor: 'initialization' stamp: 'dhn 1/26/2015 18:38'!
buttonWidth
	"Answer button width as a proportion of the width of the containing morph"
	^ 0.2! !

!AnagramWindow class methodsFor: 'initialization' stamp: 'dhn 8/25/2015 20:22'!
how
"
	AnagramWindow open.
"! !

!AnagramWindow class methodsFor: 'initialization' stamp: 'dhn 8/25/2015 20:18'!
open
	| main win |
	main _ Anagram new.
	win _ self new.
	win setLabel: 'Anagram Aid';
		model: main;
		openInWorld.
	main board: win.
	win owner doOneCycleNow.
	win buildMorphicWindow
	
! !
