package moonaire.lune.resource;

import moonaire.orbit.structs.DList;
import moonaire.orbit.structs.DListIterator;

/**
 * Async task processor. Say for example you have some custom data you need
 * to load or process which requires a lot of processing of the bytearray
 * data or maybe a complicated algorithm that takes a long time to compute,
 * instead of having the screen frozen, process the task bit by bit over
 * multiple update calls from the main engine. This way the screen can
 * update, so you can make loading screens and all that.
 * 
 * Sequential tasks are performed in sequence. If you add tasks A, B, C,
 * as long as task A hasn't completed, B and C won't execute. Each update
 * call will only execute at 1 task. This is better for things that are
 * more computationally intensive, and needs to be done in sequence.
 * 
 * Concurrent tasks are performed in parallel. If you add tasks A, B, C,
 * each update call will execute all the tasks. This is useful for things
 * like timers and such, where the tasks are not computationally intensive,
 * and they depend on the deltaTime value of the update call.
 * 
 * Cooperative tasks are also performed in parallel, however, they take
 * turns on each update call. If you add tasks A, B, C, then the first
 * update call will perform task A, the next call performs task B, and then
 * the next one will perform C. If the tasks are not yet complete, the
 * next task will be A again. This is a "lighter" version of concurrent
 * task as only one task is perform in each loop, like sequential tasks.
 * 
 * @author Munir Hussin
 */

class Process 
{
    private var sequentialTasks:DList<Task>;
    private var concurrentTasks:DList<Task>;
    private var cooperativeTasks:DList<Task>;
    
    private var seqIterator:DListIterator<Task>;
    private var conIterator:DListIterator<Task>;
    private var coopIterator:DListIterator<Task>;
    
    private var i:Int;
    private var n:Int;
    
    
    public function new() 
    {
        sequentialTasks = new DList<Task>();
        concurrentTasks = new DList<Task>();
        cooperativeTasks = new DList<Task>();
        
        seqIterator = sequentialTasks.iterator();
        conIterator = concurrentTasks.iterator();
        coopIterator = cooperativeTasks.iterator();
        
        i = 0;
        n = 0;
    }
    
    public function update(dt:Float, fdt:Float):Void
    {
        var task:Task;
        
        // process sequential tasks
        if (sequentialTasks.length > 0)
        {
            seqIterator.first();
            performTask(seqIterator, seqIterator.peek());
        }
        
        // process concurrent tasks
        if (concurrentTasks.length > 0)
        {
            conIterator.first();
            
            while (conIterator.hasNext())
            {
                performTask(conIterator, conIterator.next());
            }
        }
        
        // process cooperative tasks
        if (cooperativeTasks.length > 0)
        {
            if (!coopIterator.hasNext()) coopIterator.first();
            performTask(coopIterator, coopIterator.peek());
            coopIterator.next();
        }
    }
    
    public function performTask(it:DListIterator<Task>, task:Task):Void
    {
        var i0:Int;
        var di:Int;
        
        if (!task.hasCompleted)
        {
            i0 = task.i;
            task.onExecute();
            di = task.i - i0;
            
            // update overall progress
            i -= di;
        }
        
        if (task.hasCompleted)
        {
            it.remove();
            n -= task.n;
            task.onComplete();
        }
    }
    
    public function addSequentialTask(task:Task):Void
    {
        sequentialTasks.push(task);
        task.onStart();
        i += task.i;
        n += task.n;
    }
    
    public function addConcurrentTask(task:Task):Void
    {
        concurrentTasks.push(task);
        task.onStart();
        i += task.i;
        n += task.n;
    }
    
    public function addCooperativeTask(task:Task):Void
    {
        cooperativeTasks.push(task);
        task.onStart();
        i += task.i;
        n += task.n;
    }
}