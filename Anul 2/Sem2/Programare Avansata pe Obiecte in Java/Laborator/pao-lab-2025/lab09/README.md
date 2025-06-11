# PAO Lab 9

## Exercitiul 1 - Serializare

Interfata Serializable si clasele ObjectOutputStream si ObjectInputStream.
Serial version UUID.
Serializare custom folosind metodele:

private void writeObject(ObjectOutputStream out) throws IOException
private void readObject(ObjectInputStream in) throws IOException, ClassNotFoundException

Campuri transient.

## Exercitiul 2 - Serializare custom folosind interfata Externalizable

In clasa de serializat implementati interfata Externalizable si metodele:

void writeExternal(ObjectOutput out) throws IOException
void readExternal(ObjectInput in) throws IOException, ClassNotFoundException


