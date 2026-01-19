package example;

import java.util.HashSet;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Stream;

import org.neo4j.graphdb.Direction;
import org.neo4j.graphdb.Node;
import org.neo4j.graphdb.Relationship;
import org.neo4j.logging.Log;
import org.neo4j.procedure.Context;
import org.neo4j.procedure.Description;
import org.neo4j.procedure.Name;
import org.neo4j.procedure.Procedure;

public class GetRelationshipTypes {
    @Context
    public Log log;

    @Procedure(name = "example.getRelationshipTypes")
    @Description("Get the different relationships going in and out of a node.")
    public Stream<RelationshipTypes> getRelationshipTypes(@Name("node") Node node) {
        if (node == null) {
            return Stream.empty();
        }

        HashSet<String> outgoing = new HashSet<>();
        node.getRelationships(Direction.OUTGOING).iterator()
            .forEachRemaining(rel -> outgoing.add(rel.getType().name()));

        HashSet<String> incoming = new HashSet<>();
        node.getRelationships(Direction.INCOMING).iterator()
            .forEachRemaining(rel -> incoming.add(rel.getType().name()));

        return Stream.of(new RelationshipTypes(new ArrayList<>(incoming), new ArrayList<>(outgoing)));    
    }

    public static class RelationshipTypes {
        public List<String> outgoing;
        public List<String> incoming;

        public RelationshipTypes(List<String> incoming, List<String> outgoing) {
            this.outgoing = outgoing;
            this.incoming = incoming;
        }
    }
}