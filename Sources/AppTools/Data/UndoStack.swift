//
//  UndoStack.swift
//  
//  
//  Created by keiji0 on 2022/05/17
//  
//

/// シンプルなUndoスタック
public class UndoStack<Command> {
    
    init() {
    }
    
    /// Undoを登録する
    public func register(_ command: Command) {
        removeRedo()
        undoStack.append(command)
    }
    
    /// 全て削除する
    public func clear() {
        undoStack.removeAll()
        redoStack.removeAll()
    }
    
    /// Undoすることができるか？
    public var canUndo: Bool {
        undoStack.isAny
    }
    
    /// Undoを実行する
    public func undo() -> Command {
        let cmd = undoStack.popLast()!
        redoStack.append(cmd)
        return cmd
    }
    
    /// Undoできるカウント
    public var undoCount: Int {
        undoStack.count
    }
    
    /// Redoすることができるか？
    public var canRedo: Bool {
        redoStack.isAny
    }
    
    /// Redoを実行する
    public func redo() -> Command {
        let cmd = redoStack.popLast()!
        undoStack.append(cmd)
        return cmd
    }
    
    /// Redoできるカウント
    public var redoCount: Int {
        redoStack.count
    }
    
    // MARK: - Private
    
    private var undoStack = [Command]()
    private var redoStack = [Command]()
    
    private func removeRedo() {
        redoStack.removeAll()
    }
}
