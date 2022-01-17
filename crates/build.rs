use std::{
    path::PathBuf,
    sync::{Mutex, Arc, mpsc::{channel, Sender, self, Receiver}, atomic::{self, AtomicBool}},
    env::{var, set_var, current_dir, set_current_dir},
    fs::{self, read_to_string},
    io::{prelude::*, self,},
    future::{Future, self},
    task::{self, Wake,Poll, Context,}, 
    thread::{self,spawn, sleep, current, Thread, Builder, park, park_timeout, JoinHandle },
    process::{Output, Child, ChildStdout, Stdio, Command}
};

pub fn main() -> std::io::Result<()> {
    let zpkg: Vec<String> = vec![String::from("idula"), String::from("idli"), String::from("idlsp")];
    let cpkg: Vec<String> = vec![String::from("cdula"), String::from("cpula")];
    let (tx, rx): (Sender<String>, Receiver<String>) = mpsc::channel();
    let mut children: Vec<JoinHandle<()>> = vec![];
    let mut thread_ids: Vec<String> = Vec::with_capacity(3 as usize);
    for id in 0..5 {
        let thread_tx = tx.clone();
        let child = thread::spawn(move || {
            let st = (id as i32).to_string().clone();
            thread_tx.send(st).unwrap();
            println!("thread {} finished", id);
        });
        children.push(child);
    }
    for i in 0..5 { thread_ids.push(rx.recv().unwrap()); }
    for ch in children { ch.join().unwrap(); }

    println!("{:#?}", thread_ids);

    let handler = thread::spawn(move || {

    });
    handler.join().unwrap_or_default();
    Ok(())

}
fn build_zig() -> io::Result<()> {
    let zpp = Command::new("zig").current_dir(PathBuf::from("~/p/z/il/"))
        .args(&vec![ "cc", "-o", "./zig-out/bin/cdula", "../ext/c/main.c"])
        .output().unwrap();
    let zcc = Command::new("zig").current_dir(PathBuf::from("~/p/z/il/"))
        .args(&vec!["c++",  "-o", "./zig-out/bin/cdula", "../ext/c/main.c"])
        .output().unwrap();
    let zig = Command::new("zig").current_dir(PathBuf::from("~/p/z/il/"))
        .args(&vec!["build", "run", "--", "./src/main.zig"])
        .output().unwrap();

    io::stdout().write_all(&zpp.stdout)?;
    io::stdout().write_all(&zcc.stdout)?;
    io::stdout().write_all(&zig.stdout)?;
    Ok(())
}
