package com.unibuc.pao.lab9.ex02;

import java.io.Externalizable;
import java.io.IOException;
import java.io.ObjectInput;
import java.io.ObjectOutput;
import java.util.Objects;

public class StudentExternal implements Externalizable {

    private String cnp;

    private String name;

    private int age;

    private short group;

    private byte studyYear;

    private transient boolean studiesJava = false;
    private boolean studiesC = false;

    private static int count;

    private static final long serialVersionUID = -2812990639636624980L;

    public StudentExternal() {
        // Default constructor for Externalizable
    }

    public StudentExternal(String cnp, String name, int age, short group, byte studyYear) {
        this.cnp = cnp;
        this.name = name;
        this.age = age;
        this.group = group;
        this.studyYear = studyYear;
        count++;
    }

    public String getCnp() {
        return cnp;
    }

    public String getName() {
        return name;
    }

    public int getAge() {
        return age;
    }

    public short getGroup() {
        return group;
    }

    public byte getStudyYear() {
        return studyYear;
    }

    @Override
    public String toString() {
        count++;
        studiesJava = true;
        return "Student{" +
                "cnp='" + cnp + '\'' +
                ", name='" + name + '\'' +
                ", age=" + age +
                ", group=" + group +
                ", studyYear=" + studyYear +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (o == null || getClass() != o.getClass()) return false;
        StudentExternal student = (StudentExternal) o;
        return age == student.age && group == student.group && studyYear == student.studyYear && Objects.equals(cnp, student.cnp) && Objects.equals(name, student.name);
    }

    @Override
    public int hashCode() {
        return Objects.hash(cnp, name, age, group, studyYear);
    }


//    private void writeObject(ObjectOutputStream out) throws java.io.IOException {
//        out.defaultWriteObject();
//        out.writeBoolean(studiesJava);
//    }
//
//    private void readObject(ObjectInputStream in) throws java.io.IOException, ClassNotFoundException {
//        in.defaultReadObject();
//        studiesJava = in.readBoolean();
//    }


    @Override
    public void writeExternal(ObjectOutput out) throws IOException {
        out.writeUTF(this.getCnp());
        out.writeUTF(this.getName());
        out.writeInt(this.getAge());
        out.writeShort(this.getGroup());
        out.writeByte(this.getStudyYear());
    }

    @Override
    public void readExternal(ObjectInput in) throws IOException, ClassNotFoundException {
        this.cnp = in.readUTF();
        this.name = in.readUTF();
        this.age = in.readInt();
        this.group = in.readShort();
        this.studyYear = in.readByte();
    }

    public static int getCount() {
        return count;
    }
}
