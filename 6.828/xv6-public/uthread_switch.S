	.text

/* Switch from current_thread to next_thread. Make next_thread
 * the current_thread, and set next_thread to 0.
 * Use eax as a temporary register; it is caller saved.
 */
	.globl thread_switch
thread_switch:

	pushal

	/*save the current thread state into the structure pointed to by current_thread*/

	movl current_thread, %eax
	movl %esp, (%eax)

	/*restore next_thread's state*/

	movl next_thread, %eax
	movl (%eax), %esp

	/*make current_thread point to where next_thread was pointing to*/

	movl %eax, current_thread
	movl $0x0, next_thread

	popal

	/* YOUR CODE HERE */
	ret				/* pop return address from stack */
