export default class PlantUmlToJson {
    static fromString(str: string): PlantUmlToJson;
    static fromFile(str: string): PlantUmlToJson;
    generate(): Promise<void>;
}
