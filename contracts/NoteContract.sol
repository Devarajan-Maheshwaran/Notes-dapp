// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract NotesContract {
    uint public noteCount;

    struct Note {
        uint id;
        string title;
        string content;
        address author;
        uint timestamp;
    }

    mapping(uint => Note) public notes;

    event NoteCreated(uint indexed id, string title, address indexed author);
    event NoteEdited(uint indexed id, string newTitle, string newContent);
    event NoteDeleted(uint indexed id);

    function createNote(string memory _title, string memory _content) public {
        require(bytes(_title).length > 0, "Title cannot be empty");
        require(bytes(_content).length > 0, "Content cannot be empty");

        noteCount++;
        notes[noteCount] = Note({
            id: noteCount,
            title: _title,
            content: _content,
            author: msg.sender,
            timestamp: block.timestamp
        });

        emit NoteCreated(noteCount, _title, msg.sender);
    }

    function getNote(uint _id) public view returns (Note memory) {
        require(_id > 0 && _id <= noteCount, "Note does not exist");
        return notes[_id];
    }

    function editNote(uint _id, string memory _newTitle, string memory _newContent) public {
        Note storage note = notes[_id];
        require(note.author == msg.sender, "You are not the author");

        note.title = _newTitle;
        note.content = _newContent;

        emit NoteEdited(_id, _newTitle, _newContent);
    }

    function deleteNote(uint _id) public {
        Note storage note = notes[_id];
        require(note.author == msg.sender, "You are not the author");

        delete notes[_id];
        emit NoteDeleted(_id);
    }
}
